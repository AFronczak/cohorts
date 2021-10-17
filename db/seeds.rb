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
