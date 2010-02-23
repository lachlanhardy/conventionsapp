RACK_ROOT = ::File.dirname(__FILE__)
ENV['TMPDIR'] = ::File.join(RACK_ROOT, 'tmp')

# the middlewares
require 'rack'

# the app
require 'sinatra'
require 'application'

run Application::App.new
