RACK_ROOT = ::File.dirname(__FILE__)
ENV['TMPDIR'] = ::File.join(RACK_ROOT, 'tmp')

# the middlewares
require 'rack'
require 'lib/rack/trailingslash'
require 'lib/rack/catch_redirect'

# the app
require 'sinatra'
require 'application'

set :options, {
  :views => ::File.join(RACK_ROOT, 'views'),
  :app_file => ::File.join(RACK_ROOT, 'application.rb'),
  :run => false, 
  :env => ENV['RACK_ENV'] ? ENV["RACK_ENV"].to_sym : "development",
  :raise_errors => true
  }


use Rack::Session::Cookie
use TrailingSlash
use Rack::CatchRedirect
# use Rack::Lint # for Rack dev
run Application::App.new
