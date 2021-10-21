class User < ActiveRecord::Base
	has_many :orders
end

class Order < ActiveRecord::Base
	belongs_to :user

	def self.cohorts(count)
		earliest_date = Order.first.created_at
		last_date = User.last.created_at
	
		data = Order.joins("JOIN (SELECT users.id, MIN(users.created_at) as cohort_date FROM users  WHERE (created_at > '#{earliest_date}') GROUP BY id) AS cohorts ON orders.user_id = cohorts.id").
		select("orders.user_id, orders.id, orders.order_num, orders.created_at, cohort_date, FLOOR(extract(epoch from (orders.created_at - cohort_date))/604800) as periods_out").where("orders.created_at > '#{earliest_date}' and orders.created_at < '#{last_date}'")
	
		users = User.where("created_at > '#{earliest_date}' and created_at < '#{last_date}'")
	
		unique_data = data.all.uniq{|d| [d.send("id"), d.cohort_date, d.periods_out] }
	
		analysis = unique_data.group_by{|d| d.cohort_date.at_beginning_of_week.to_date}

		cohort_hash = Hash[analysis.sort_by { |cohort, data| cohort }.reverse]

		user_buckets = users.all.group_by{|d| d.created_at.at_beginning_of_week.to_date}
		table = {}

		cohort_hash.keys[0...count].each do |key|
			arr = cohort_hash[key]
			periods = []
			first_time = []
		
			table[key] = {}
	
			# orderers
			cohort_hash.size.times{|i| periods << arr.count{|d| d.periods_out.to_i == i} if arr}
	
			# first time orderers     
			cohort_hash.size.times{|i| first_time << arr.count{|d| if i.eql?(0); d.periods_out.to_i == i && d.order_num.to_i >= 1; else; d.periods_out.to_i == i && d.order_num.to_i == 1; end} if arr}
			table[key][:date] = key
			table[key][:count] = periods
			table[key][:total_users] = user_buckets[key].length
			table[key][:first_time] = first_time
			table[key][:data] = arr
		end
		return table
	end
end