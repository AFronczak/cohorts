# myapp.rb

require 'sinatra'
require 'sinatra/activerecord'

set :database_file, "config/database.yml"

get '/' do
  # if app becomes modular, will need to use this
  # register Sinatra::ActiveRecordExtension 
  erb :cohorts
end 