# require 'csv'

# def seed_from_csv(model, path)
# 	csv_text = File.read(File.join(Sinatra::Application.root_path, "#{path}"))
# 	csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# 	csv.each do |row|
# 		m = model.create(row.to_hash)
# 		m.touch(time: row.to_hash[:updated_at])
# 	end
# end

# seed_from_csv(User, '/lib/seeds/users.csv')
# seed_from_csv(Order, '/lib/seeds/orders.csv')

# users_path = File.join(Sinatra::Application.root_path, "/lib/seeds/users.csv")
# orders_path = File.join(Sinatra::Application.root_path, "/lib/seeds/orders.csv")
# connection = ActiveRecord::Base.connection()

# sql = <<-EOL
# 	COPY users FROM "#{users_path.tr('"', "'")}" WITH (FORMAT csv);
#   COPY orders FROM "#{orders_path.tr('"', "'")}" WITH (FORMAT csv);
# EOL

# sql.split(';').each do |s|
#   connection.execute(s.strip) unless s.strip.empty?
# end