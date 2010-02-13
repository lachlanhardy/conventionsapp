require 'sinatra/base'
require 'haml'
require 'dm-core'
require 'sinatra_auth_gmail'

module Application
  enable :sessions
  set :haml, {:format => :html5, :attr_wrapper => '"'}
  # set :environment => 'production' # for testing minification etc
  
  class App < Sinatra::Application
    register Sinatra::Auth::Gmail

    class Users
      include DataMapper::Resource
      property :id, Serial
      property :first_name, String
      property :last_name, String
      property :email, String, :format => :email_address
      property :homepage, String
      property :google_acct_id, String, :format => :email_address
      property :google_identity_url, String
    end
    
    Dir.glob("lib/helpers/*").each do |helper|
      require "#{File.dirname(__FILE__)}/#{helper}"
    end

    helpers do
      include Application::Helpers
    end
    
    configure do
      DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
      DataMapper.auto_upgrade!
    end

    before do
      mobile_request? ? @mobile = ".mobile" : @mobile = ""
    end

    error do
      handle_fail
    end

    not_found do
      handle_fail
    end
    
    # homepage
    get '/' do
      deliver :index
    end
    
    get '/sign-in/' do
      authorize!
      # some query shit my brain can't think of right now
      # if (gmail_user.email != @user.email)
        redirect "/signup/"
      # else
        # @signed_in = true
        # redirect "/"
      # end
    end
    
    get '/signup/' do
      @user = Users.new
      deliver :signup
    end
    
    post '/create/' do
      @user = Users.new(params[:user])
      @user.first_name = gmail_user.first_name
      @user.last_name = gmail_user.last_name
      @user.google_acct_id = gmail_user.email
      @user.google_identity_url = gmail_user.identity_url

      if @user.save!
        redirect "/"
      else
        deliver :signup
      end
    end
    
    get '/:page/' do
      deliver :"#{params[:page]}"
    end

  end
end
