# myapp.rb

require 'sinatra'
require 'sinatra/activerecord'
require 'active_support/all'
require 'pry'
require './models'

set :database_file, "config/database.yml"
set :root_path, File.dirname(__FILE__)

get '/' do
  last_date = User.last.created_at.to_datetime
  @cohorts = loop_through_dates_return_users(last_date)

  erb :cohorts
end 

def loop_through_dates_return_users(date)
  earliest_date = Order.select("MIN(created_at)")[0].min
  last_date = User.last.created_at

  data = Order.joins("JOIN (SELECT users.id, MIN(users.created_at) as cohort_date FROM users  WHERE (created_at > '#{earliest_date}') GROUP BY id) AS cohorts ON orders.user_id = cohorts.id").
  select("orders.user_id, orders.id, orders.order_num, orders.created_at, cohort_date, FLOOR(extract(epoch from (orders.created_at - cohort_date))/604800) as periods_out").where("orders.created_at > '#{earliest_date}' and orders.created_at < '#{last_date}'")

  users = User.where("created_at > '#{earliest_date}' and created_at < '#{last_date}'")

  unique_data = data.all.uniq{|d| [d.send("id"), d.cohort_date, d.periods_out] }

  analysis = unique_data.group_by{|d| Time.parse(d.cohort_date.to_s + " UTC").at_beginning_of_week.to_date}
  cohort_hash =  Hash[analysis.sort_by { |cohort, data| cohort }.reverse]

  user_buckets = users.all.group_by{|d| Time.parse(d.created_at.to_s + " UTC").at_beginning_of_week.to_date}
  table = {}

  cohort_hash.each do |arr|
    periods = []
    first_time = []
  
    table[arr[0]] = {}

    # method for orderers
    cohort_hash.size.times{|i| periods << arr[1].count{|d| d.periods_out.to_i == i} if arr[1]}

    # method for first time orderers        
    cohort_hash.size.times{|i| first_time << arr[1].count{|d| if i.eql?(0); d.periods_out.to_i == i && d.order_num.to_i >= 1; else; d.periods_out.to_i == i && d.order_num.to_i == 1; end} if arr[1]}
    table[arr[0]][:dates] = "#{arr[0].at_beginning_of_week.try(:strftime, "%m/%d")}-#{arr[0].at_end_of_week.try(:strftime, "%m/%d")}"
    table[arr[0]][:count] = periods
    table[arr[0]][:total_users] = user_buckets[arr[0]].length
    table[arr[0]][:first_time] = first_time
    table[arr[0]][:data] = arr[1]
  end

  return table
end