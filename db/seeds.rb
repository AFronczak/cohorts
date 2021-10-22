require 'csv'

users_path = File.join(Sinatra::Application.root_path, '/lib/seeds/users.csv')
orders_path = File.join(Sinatra::Application.root_path, '/lib/seeds/orders.csv')
connection = ActiveRecord::Base.connection()

sql = <<-EOL
	COPY users FROM '#{users_path}' WITH (FORMAT csv);
  COPY orders FROM '#{orders_path}' WITH (FORMAT csv);
EOL

sql.split(';').each do |s|
  connection.execute(s.strip) unless s.strip.empty?
end