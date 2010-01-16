root_dir = File.dirname(__FILE__)

# the middlewares
require 'rack'
require 'lib/rack/trailingslash'

# the app
require 'sinatra'
require 'application'

set :options, {
  :views => File.join(root_dir, 'views'),
  :app_file => File.join(root_dir, 'application.rb'),
  :run => false, 
  :env => ENV['RACK_ENV'] ? ENV["RACK_ENV"].to_sym : "development",
  :raise_errors => true
  }
  
if ENV['RACK_ENV'] != 'production'
  log = File.new("log/sinatra.log", "a")
  STDOUT.reopen(log)
  STDERR.reopen(log)
end

use TrailingSlash
# use Rack::Lint # for Rack dev
# run Sinatra::Application
run Application::App.new
