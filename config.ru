require 'rubygems'
require 'sinatra'
require 'server.rb'
require 'rack/cache'

root_dir = File.dirname(__FILE__)

set :environment, ENV['RACK_ENV'].to_sym
set :root,        root_dir
set :app_file,    File.join(root_dir, 'server.rb')


use Rack::Cache,
  :verbose     => true,
  :metastore   => "file:#{File.join(root_dir, '/public/meta')}"
  :entitystore => "file:#{File.join(root_dir, '/public/body')}"
  
disable :run
run Sinatra::Application