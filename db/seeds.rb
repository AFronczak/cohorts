require 'csv'

def seed_from_csv(model, path)
	csv_text = File.read(File.join(Sinatra::Application.root_path, "#{path}"))
	csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
	csv.each do |row|
		model.create(row.to_hash)
	end
end

seed_from_csv(User, '/lib/seeds/users.csv')
seed_from_csv(Order, '/lib/seeds/orders.csv')


# orders_csv_text = File.read(File.join(Sinatra::Application.root_path, '/lib/seeds/orders.csv'))
# orders_csv = CSV.parse(orders_csv_text, :headers => true, :encoding => 'ISO-8859-1')
# orders_csv.each do |row|
#   Order.create(row.to_hash)
# end

# users_csv_text = File.read(File.join(Sinatra::Application.root_path, '/lib/seeds/users.csv'))
# users_csv = CSV.parse(users_csv_text, :headers => true, :encoding => 'ISO-8859-1')
# users_csv.each do |row|
#   User.create(row.to_hash)
# end
