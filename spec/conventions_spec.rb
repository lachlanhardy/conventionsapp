require File.join(File.dirname(__FILE__), 'spec_helper')

describe "My App" do
  include Rack::Test::Methods

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
end
