RACK_ROOT = File.expand_path(File.join(::File.dirname(__FILE__), "..")) unless defined?(RACK_ROOT)

def app
  @app ||= ::Application::App
end
def app_rb
  File.join(File.dirname(__FILE__), '..', 'application.rb')
end

require 'sinatra'
require 'rack/test'
require 'spec'
require 'machinist/data_mapper'
require 'sham'
require 'faker'
require app_rb

require File.join(File.dirname(__FILE__), "blueprints")


set :app_file, app_rb
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

Spec::Runner.configure do |config|
  config.before(:all)    { Sham.reset(:before_all)  }
  config.before(:each)   { Sham.reset(:before_each) }
end
