require 'csv'

unless Rails.env.production?
  Apartment::Tenant.switch!('budlight')

  csv_text = File.read(Rails.root.join('lib', 'seeds', 'nfl_teams.csv'))
  csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
  csv.each do |row|
    team = {
      name: row['name'],
      account_id: row['account_id'],
      type: row['type'],
      initials: row['initials'],
      abbreviation: row['abbreviation'],
      image: row['image'],
      entry_image: row['entry_image'],
      local_image: row['local_image'],
      division: row['division'],
      lat: row['lat'].to_f,
      long: row['long'].to_f,
      sponsored: row['sponsored'],
      active: row['active']
    }
    count += 1
    puts "#{team[:name]} initialized with #{count}"
  end

end

