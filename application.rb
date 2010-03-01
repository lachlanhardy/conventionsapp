require 'sinatra/base'
require 'haml'
require 'dm-core'
gem 'sinatra_auth_gmail', '~>0.1'
require 'sinatra_auth_gmail'
require 'pp'
require 'lib/rack/trailingslash'
require 'lib/rack/catch_redirect'

module Application
  enable :sessions
  set :haml, {:format => :html5, :attr_wrapper => '"'}
  # set :environment => 'production' # for testing minification etc
  set :options, {
    :run => false,
    :env => ENV['RACK_ENV'] ? ENV["RACK_ENV"].to_sym : "development",
    :raise_errors => true
  }


  use Rack::Session::Cookie
  use TrailingSlash
  use Rack::CatchRedirect

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

      Warden::Manager.after_authentication do |user, auth, opts|
        if u = User.first(:google_identity_url => user.identity_url)
          u
        else
          user.first_name = unarrayify(user.first_name)
          user.last_name = unarrayify(user.last_name)
          user.email = unarrayify(user.email)
          auth.set_user user, :scope => :google
          throw(:redirect, "/signup/")
        end
      end
    end

    before do
      if params['openid.identity']
        authenticate!
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
      authenticate!
      redirect '/'
    end

    get '/test/' do
      authenticate!
      "<h1>TEST PAGE. #{gmail_user.first_name}</h1>"
    end

    get '/sign-out/' do
      logout!
      redirect '/'
    end

    get '/signup/' do
      authenticate! :scope => :google unless authenticated?
      @user = User.new
      deliver :signup
    end

    post '/create/' do
      @user = User.new(params[:user])
      @user.first_name          = google_user.first_name
      @user.last_name           = google_user.last_name
      @user.google_acct_id      = google_user.email
      @user.google_identity_url = google_user.identity_url

      if @user.save
        # Update our user object now we have a fully-fledged member
        warden.set_user(@user)
        logout! :google
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
