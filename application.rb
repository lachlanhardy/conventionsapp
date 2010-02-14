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
    
    class User
      include DataMapper::Resource
      property :id, Serial
      property :first_name, String
      property :last_name, String
      property :email, String, :format => :email_address
      property :homepage, String
      property :google_acct_id, String, :format => :email_address
      property :google_identity_url, String, :length => 255
    end
    
    Dir.glob("lib/helpers/*").each do |helper|
      require "#{File.dirname(__FILE__)}/#{helper}"
    end

    helpers do
      include ::Application::Helpers
    end
    
    configure do
      DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
      DataMapper.auto_upgrade!

      # Setup warden user handling
      Warden::Manager.after_authentication do |user, auth, opts|
        # Check if we have a matching user in the DB
        if u = User.first(:google_identity_url => user.identity_url)
          user = u
        else
          # a new user. Send to signup page
          throw(:redirect, "/signup/")
        end
      end
    end

    before do
      # the warden openid strategy only completes the request if authenticate is
      # called on the return page, which by default is / . This seems to be buggy
      # behavior, to work around it we catch all incoming requests, and if they look
      # like an openid response, we call authorize! to make it complete.
      if params['openid.identity']
        authorize!
        # clean up params
        redirect request.path
      end

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
      auth
      redirect '/'
    end

    get '/test/' do
      auth
      "<h1>TEST PAGE. #{gmail_user.first_name}</h1>"
    end

    get '/sign-out/' do
      env['warden'].logout
      redirect '/'
    end
    
    get '/signup/' do
      @user = User.new
      deliver :signup
    end
    
    post '/create/' do
      @user = User.new(params[:user])
      @user.first_name = gmail_user.first_name
      @user.last_name = gmail_user.last_name
      @user.google_acct_id = gmail_user.email
      @user.google_identity_url = gmail_user.identity_url

      if @user.save
        # Update our user object now we have a fully-fledged member
        env['warden'].set_user(@user)
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
