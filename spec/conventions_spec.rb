require File.join(File.dirname(__FILE__), 'spec_helper')

describe "My App" do
  include Rack::Test::Methods
  include Warden::Test::Helpers

  after{ Warden.test_reset! }

  def last_request_went_to_google?
    uri = URI.parse(last_response.headers['Location'])
    uri.host =~ /google.com$/
  end

  def attempted_authentication?
    !!(last_request_went_to_google? &&
      (300..399).include?(last_response.status))
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end

  it "should return the correct content-type when viewing root" do
    get '/'
    last_response.headers["Content-Type"].should == "text/html"
  end

  it "should return 404 when page cannot be found" do
    get '/404'
    last_response.status.should == 404
  end

  it "should return blah blah blah when viewing root" do
    get '/'
    last_response.body == "blah blah blah"
  end

  it "should redirect to google when accessing a protected resource" do
    get '/test/'
    attempted_authentication?.should be_true
  end

  it "should provide access to the resource when logged in" do
    user = Application::App::User.make
    login_as user
    get "/test/"
    last_response.status.should == 200
  end

  it "should try and log me in when I access '/sign-in/'" do
    get "/sign-in/"
    attempted_authentication?.should be_true
  end

  it "should redirect to google when no-one is signed in" do
    get "/signup/"
    attempted_authentication?.should be_true
  end

  it "should not redirect to google when the google user is signed in" do
    login_as mock("user", :null_object => true), :scope => :google
    get "/signup/"
    last_response.should be_successful
  end

end
