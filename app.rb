# myapp.rb

require 'sinatra'
require 'sinatra/activerecord'
require 'active_support/all'
require 'pry'
require './models'

set :database_file, "config/database.yml"
set :root_path, File.dirname(__FILE__)

get '/' do
  @cohort_count = 8
  @cohorts = Order.cohorts(@cohort_count)

  erb :cohorts
end 

post '/' do
  @cohort_count = params[:cohort_count].to_i
  @cohorts = Order.cohorts(@cohort_count)

  erb :cohorts
end
