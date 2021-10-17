# myapp.rb

require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database_file, "config/database.yml"
set :root_path, File.dirname(__FILE__)

get '/' do
  @users = Users.order('created_at ASC')
  @cohorts
  erb :cohorts
end 
