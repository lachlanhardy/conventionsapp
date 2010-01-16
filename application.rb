require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'twitter'
require 'yaml'
require 'net/http'
require 'pp' # only for dev work

module Application

  set :haml, {:format => :html5, :attr_wrapper => '"'}
  # set :environment => 'production' # for testing minification etc
  
  class App < Sinatra::Application
    Dir.glob("lib/helpers/*").each do |helper|
      require "#{File.dirname(__FILE__)}/#{helper}"
    end

    helpers do
      include Application::Helpers
    end
    
    configure do
      #configure_avatars(Dir.glob("public/images/userlist.yaml")[0])
    end

    error do
      handle_fail
    end

    not_found do
      handle_fail
    end
    
    # homepage
    get '/' do
      haml :index
    end

    # homepage
    get '/:page/' do
      haml params[:page].to_sym
    end


  end
end
