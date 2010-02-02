require 'sinatra/base'
require 'haml'
gem 'oauth'
require 'oauth/consumer'
require 'dm-core'

module Application

  enable :sessions
  set :haml, {:format => :html5, :attr_wrapper => '"'}
  # set :environment => 'production' # for testing minification etc
  
  class App < Sinatra::Application
    class Users
      include DataMapper::Resource
      property :id, Serial
      property :email, String
      property :twitter_screen_name, String
      property :twitter_user_id, String
      property :twitter_oauth_token, String
      property :twitter_oauth_token_secret, String
      property :password, String
      property :openid, String
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
      # TODO: split these out to a config file
      @consumer = OAuth::Consumer.new "KKIsmmyjgHy4nUtHKuUeg", "at1tKkA5PPq8QHlAN8uByWfd3Zn7eYFks7U9cJMnW8", {:site=>"http://twitter.com"}
      puts @consumer
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
      do_oauth_dance
      deliver :index
    end
    
    get '/signup/' do
      @access_token = OAuth::RequestToken.new(@consumer, session[:request_token], session[:request_token_secret]).get_access_token(:oauth_verifier =>params[:oauth_verifier])
      
      session[:access_token] = @access_token

      @user = Users.new
      haml :signup
    end
    post '/create/' do
      @user = Users.new(params[:user])
      @user.twitter_screen_name = session[:access_token][:screen_name]
      @user.twitter_user_id = session[:access_token][:user_id]
      @user.twitter_oauth_token = session[:access_token][:oauth_token]
      @user.twitter_oauth_token_secret = session[:access_token][:oauth_token_secret]

      if @user.valid? && @user.save!
        redirect "/thank-you/"
      else
        haml :signup
      end
    end
    
    get '/:page/' do
      deliver :"#{params[:page]}"
    end

  end
end
