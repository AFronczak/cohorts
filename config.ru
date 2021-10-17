require 'rubygems'
require 'bundler'
require './config/environment'

Bundler.require 

require './app'
run Sinatra::Application