def app
  @app ||= ::Application::App
end
def app_rb
  File.join(File.dirname(__FILE__), '..', 'application.rb')
end

require 'sinatra'
require 'rack/test'
require 'spec'
require app_rb

set :app_file, app_rb
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false
