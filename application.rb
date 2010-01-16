# require 'rubygems'
require 'sinatra/base'
require 'haml'

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
    
    # helper_method :mobile_request?
    def mobile_request?
      # mobile_user_agent_patterns.any? {|r| request.headers['User-Agent'] =~ r}
      mobile_user_agent_patterns.any? {|r| 
        # haml_concat(request.env)
        request.env['REQUEST_PATH/HTTP_USER_AGENT'] =~ r
        }
    end
    def mobile_user_agent_patterns
      [
        /AppleWebKit.*Mobile/,
        /Android.*AppleWebKit/
      ]
    end
    
    # homepage
    get '/' do
      haml :index
    end
    
    # homepage
    get '/index.mobile' do
      haml :index
    end

    get '/:page/' do
      haml params[:page].to_sym
    end

  end
end
