class DataMigration
  def self.preference_to_roles tenant:
    Apartment::Tenant.switch(tenant) do
      Team.active.each do |team|
        User.joins(:preference).where("preferences.data->>'owner_id' = :owner_id", owner_id: team.id.to_s).each do |user|
          user.add_role team.name.downcase.split(' ').join('_').to_sym, team unless user.has_role?(team.name.downcase.split(' ').join('_').to_sym, team) 
          print "Switched #{user.first_name} to #{team.name} using Roles."
        end
      end
    end
  end

  def self.update_gender tenant:
    Apartment::Tenant.switch(tenant) do
      User.all.each do |user|
        response = HTTParty.get("https://api.genderize.io/?name=#{user.first_name}")
        json_response = JSON.parse(response.body)
        user.update_attributes(gender: json_response["gender"]) if user.gender.nil? and json_response["probability"] > 0.75
      end
    end
  end

  def self.update_team_details_for tenant:, league:
    Apartment::Tenant.switch(tenant) do
      response = Faraday.get("https://erikberg.com/#{league}/teams.json")
      json_response = JSON.parse(response.body)
      json_response.each do |team|
        json_team = team['team_id'].split('-').map(&:capitalize).join(' ')
        t = Team.find_by(name: json_team)
        t.update_attributes(initials: team["abbreviation"], abbreviation: team["last_name"]) if t
      end
    end
  end

  def self.update_team_details_for tenant:
    Apartment::Tenant.switch(tenant) do
      [
        { name: "Buffalo Bills", abbreviation: "Bills", division: "afc", image: "https://cdn.freebiesupply.com/images/large/2x/buffalo-bills-logo-transparent.png" },
        { name: "Miami Dolphins", abbreviation: "Dolphins", division: "afc", image: "https://cdn.freebiesupply.com/images/large/2x/miami-dolphins-logo-transparent.png" },
        { name: "New England Patriots", abbreviation: "Patriots", division: "afc", image: "https://cdn.freebiesupply.com/images/large/2x/new-england-patriots-logo-transparent.png" },
        { name: "New York Jets", abbreviation: "Jets", division: "afc", image: "https://cdn.freebiesupply.com/images/large/2x/new-york-jets-logo-transparent.png" },
        { name: "Cincinnati Bengals", abbreviation: "Bengals", division: "afc", image: "https://cdn.freebiesupply.com/logos/large/2x/cinncinati-bengals-1-logo-png-transparent.png" },
        { name: "Baltimore Ravens", abbreviation: "Ravens", division: "afc", image: "https://cdn.freebiesupply.com/images/thumbs/1x/baltimore-ravens-logo.png" },
        { name: "Indianapolis Colts", abbreviation: "Colts", division: "afc", image: "https://cdn.freebiesupply.com/images/large/2x/indianapolis-colts-logo-transparent.png" },
        { name: "Tennessee Titans", abbreviation: "Titans", division: "afc", image: "https://cdn.freebiesupply.com/images/large/2x/tennessee-titans-logo-transparent.png" },
        { name: "Denver Broncos", abbreviation: "Broncos", division: "afc", image: "https://cdn.freebiesupply.com/images/thumbs/1x/denver-broncos-logo.png" },
        { name: "Kansas City Chiefs", abbreviation: "Chiefs", division: "afc", image: "https://cdn.freebiesupply.com/images/thumbs/1x/kansas-city-chiefs-logo.png" },
        { name: "Los Angeles Charers", abbreviation: "Chargers", division: "afc", image: "https://cdn.freebiesupply.com/logos/large/2x/san-diego-chargers-logo-png-transparent.png" },
        { name: "Oakland Raiders", abbreviation: "Raiders", division: "afc", image: "https://cdn.freebiesupply.com/images/large/2x/oakland-raiders-logo-transparent.png" }
      ]
    end
  end

  def self.remove_jsonb tenant:, model:, field:
    Apartment::Tenant.switch(tenant) do
      model.class.all.each do |object|
        data = object.data.reject {|k| k == field }
        object.update_attributes(data: data)
      end
    end
  end

  def self.update_broadcast_labels tenant:
    Apartment::Tenant.switch(tenant) do
      Team.all.each do |team|
        team.targets.create(name: "#{team.class.name} #{team.id}", label_id: team.broadcast_label_id, category: "Global")
      end
    end
  end

  def self.update_coords tenant:
    Apartment::Tenant.switch(tenant) do
      teams = [{:name=>"Los Angeles Dodgers", :lat=> 34.052230834961, :long=> -118.24368286133}, {:name=>"Toronto Blue Jays", :lat=> 43.70011138916, :long=> -79.416297912598}, {:name=>"Minnesota Twins", :lat=> 46.250240325928, :long=> -94.250549316406}, {:name=>"Chicago White Sox", :lat=> 41.850028991699, :long=> -87.650047302246}, {:name=>"Washington Nationals", :lat=> 38.895111083984, :long=> -77.03636932373}, {:name=>"Miami Marlins", :lat=> 25.774269104004, :long=> -80.193656921387}, {:name=>"Arizona Diamondbacks", :lat=> 34.500301361084, :long=> -111.5009765625}, {:name=>"Philadelphia Phillies", :lat=> 39.952331542969, :long=> -75.163787841797}, {:name=>"Chicago Cubs", :lat=> 41.850028991699, :long=> -87.650047302246}, {:name=>"St Louis Cardinals", :lat=> 38.627269744873, :long=> -90.197891235352}, {:name=>"Baltimore Orioles", :lat=> 39.290378570557, :long=> -76.612190246582}, {:name=>"New York Yankees", :lat=> 40.71427154541, :long=> -74.005966186523}, {:name=>"Cincinnati Reds", :lat=> 39.127109527588, :long=> -84.514389038086}, {:name=>"Tampa Bay Rays", :lat=> 27.947519302368, :long=> -82.458427429199}, {:name=>"Texas Rangers", :lat=> 32.735691070557, :long=> -97.108070373535}, {:name=>"Los Angeles Angels", :lat=> 34.052230834961, :long=> -118.24368286133}, {:name=>"Oakland Athletics", :lat=> 37.804370880127, :long=> -122.27079772949}, {:name=>"San Diego Padres", :lat=> 32.715709686279, :long=> -117.16471862793}, {:name=>"New York Mets", :lat=> 40.71427154541, :long=> -74.005966186523}, {:name=>"Houston Astros", :lat=> 29.76328086853, :long=> -95.363273620605}]

      teams.each do |team|
        t = Team.find_by(name: team[:name])
        t.update_attributes(lat: team[:lat], long: team[:long] ) if t
      end
    end
  end

  def remove_dups tenant:, user:
    Apartment::Tenant.switch(tenant) do
      ids = user.picks.select(:event_id).group(:event_id).having("count(*) > 1")
      duplicates = user.picks.where(event_id: ids)
      if duplicates.length == 2
        duplicates.last.destroy
      else
        puts "NOT 2!"
      end
    end
  end

  def self.add_local_image tenant:
    Apartment::Tenant.switch(tenant) do
      Team.active.each do |team|
        local_image = "https://budweiser-sweep-assets.s3.amazonaws.com/#{team.name.split(' ').map(&:downcase).join('_')}_local_image.png"
        team.update_attributes(local_image: local_image)
      end
    end
  end

  def self.destroy_existing_labels tenant:
    Apartment::Tenant.switch(tenant) do
      ids = %w[2270087886386329 2172397399508220 1837615989673390 1828521320581471 2510310578980060 2175091955917984 2078149078968108 1694716337297531 2464459606919425 2258037547611498 2146409175427900 2843418632335794 2654852247890472 2041441535954622 2586660084740940 2578308915531990 2224001087682719 2209729729114910 2167248286697227 2120441211393738]
      ids.each {|id| FacebookMessaging::Broadcast.destroy(label_id: id) }
    end
  end

  def self.create_targets_for_teams tenant:
    Apartment::Tenant.switch(tenant) do
      Team.active.each do |team|
        FacebookMessaging::Broadcast.create_target_for(resource: team, category: "Team")
      end
    end
  end

  def create_slate tenant:, team_name:, abbreviation:, owner_id:, start_time:, standing:
    Apartment::Tenant.switch(tenant) do
      slate = Slate.create(name: team_name, local: true, owner_id: owner_id, start_time: start_time, standing: standing)
      ["Will the #{abbreviation} win? The #{abbreviation} won 11 games last season.", "Will the #{abbreviation} throw for 250 yards or more? The #{abbreviation} averaged 257.8 passing yards per game last season.", "Will the #{abbreviation} defense create 2 or more turnovers? The #{abbreviation} averaged 2.5 takeaways per game last season.", "Will the #{abbreviation} score 3 or more touchdowns? In 2018, the #{abbreviation} averaged 2.8 touchdowns per game.", "Will the #{abbreviation} sack the opposing quarterback 2 or more times? In 2018, the #{abbreviation} averaged 2.3 sacks per game.", "Will the #{abbreviation} make 1 or more field goals? The #{abbreviation} averaged 1.2 made field goals per game last season."].each_with_index do |description, index|
        slate.events.create(description: description, order: index+1)
      end
    end
  end

  def self.upload_teams
    Apartment::Tenant.switch!('budlight')
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'nfl_teams.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    count = 0
    csv.each do |row|
      t = Team.new
      t.name = row['name']
      t.account_id = row['account_id']
      t.type = row['type']
      t.initials = row['initials']
      t.abbreviation = row['abbreviation']
      t.image = row['image']
      t.entry_image = row['entry_image']
      t.local_image = row['local_image']
      t.division = row['division']
      t.lat = row['lat'].to_f
      t.long = row['long'].to_f
      t.sponsored = row['sponsored']
      t.active = row['active']
      t.save
      puts "#{t.name} saved"
    end
  end

  def self.upload_products
    Apartment::Tenant.switch!('budlight')
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'nfl_products.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    count = 0
    csv.each do |row|
      t = Product.new
      t.name = row['name']
      t.owner_id = Team.find_by(name: row['team']).id
      t.category = row['category']
      t.save
      puts "#{t.name} saved"
    end
  end

  def self.create_playing_rules
    first_states = [["IN", "Indiana"], ["MA", "Massachusetts"], ["ME", "Maine"], ["MN", "Minnesota"], ["NC", "North Carolina"], ["NJ", "New Jersey"], ["VA", "Virginia"], ["WA", "Washington"]]
    second_states = [["AZ", "Arizona"], ["CO", "Colorado"], ["DC", "District of Columbia"], ["FL", "Florida"], ["IL", "Illinois"], ["KY", "Kentucky"], ["MD", "Maryland"], ["NY", "New York"], ["OR", "Oregon"], ["RI", "Rhode Island"], ["TN", "Tennessee"], ["WY", "Wyoming"]]
    first_states.each do |state|
      DrizlyRule.create(name: state[1], abbreviation: state[0], category: "Playing", eligible: true, level: 1)
    end
    second_states.each do |state|
      DrizlyRule.create(name: state[1], abbreviation: state[0], category: "Playing", eligible: true, level: 2)
    end
  end

  def self.create_sweep_rules
    first_states = [["AZ", "Arizona"], ["CO", "Colorado"], ["DC", "District of Columbia"], ["FL", "Florida"], ["IL", "Illinois"], ["KY", "Kentucky"], ["MD", "Maryland"], ["NY", "New York"], ["OR", "Oregon"], ["RI", "Rhode Island"], ["TN", "Tennessee"], ["WY", "Wyoming"]]
    first_states.each do |state|
      DrizlyRule.create(name: state[1], abbreviation: state[0], category: "Sweep", eligible: true, level: 1)
    end
  end

  def self.upload_drizly_promotions name:, category:, value:, level:
    csv_text = File.read(Rails.root.join('lib', 'seeds', "#{name}_promo.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    count = 0
    csv.each do |row|
      t = DrizlyPromotion.new
      t.category = category
      t.code = row["redemption_code"]
      t.value = value
      t.level = level
      t.save
    end
  end

end