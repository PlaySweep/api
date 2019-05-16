class DataMigration
  def self.preference_to_roles
    Apartment::Tenant.switch!('budweiser')
    Team.active.each do |team|
      User.joins(:preference).where("preferences.data->>'owner_id' = :owner_id", owner_id: team.id.to_s).each do |user|
        user.add_role team.name.downcase.split(' ').join('_').to_sym, team unless user.has_role?(team.name.downcase.split(' ').join('_').to_sym, team) 
        print "Switched #{user.first_name} to #{team.name} using Roles."
      end
    end
    puts "All done."
  end

  def self.update_gender
    Apartment::Tenant.switch!('budweiser')
    User.all.each do |user|
      response = HTTParty.get("https://api.genderize.io/?name=#{user.first_name}")
      json_response = JSON.parse(response.body)
      user.update_attributes(gender: json_response["gender"]) if user.gender.nil? and json_response["probability"] > 0.75
    end
  end

  def self.update_team_details_for league
    Apartment::Tenant.switch!('budweiser')
    response = Faraday.get("https://erikberg.com/#{league}/teams.json")
    json_response = JSON.parse(response.body)
    json_response.each do |team|
      json_team = team['team_id'].split('-').map(&:capitalize).join(' ')
      t = Team.find_by(name: json_team)
      t.update_attributes(initials: team["abbreviation"], abbreviation: team["last_name"]) if t
    end
  end

  def self.remove_jsonb
    Apartment::Tenant.switch!('budweiser')
    Slate.all.each do |slate|
      data = slate.data.reject {|k| k == "prizing_category" }
      slate.update_attributes(data: data)
    end
  end

  def self.update_broadcast_labels
    Apartment::Tenant.switch!('budweiser')
    Team.all.each do |team|
      team.targets.create(name: "#{team.class.name} #{team.id}", label_id: team.broadcast_label_id, category: "Global")
    end
  end

  def self.update_coords
    teams = [{:name=>"Los Angeles Dodgers", :lat=> 34.052230834961, :long=> -118.24368286133}, {:name=>"Toronto Blue Jays", :lat=> 43.70011138916, :long=> -79.416297912598}, {:name=>"Minnesota Twins", :lat=> 46.250240325928, :long=> -94.250549316406}, {:name=>"Chicago White Sox", :lat=> 41.850028991699, :long=> -87.650047302246}, {:name=>"Washington Nationals", :lat=> 38.895111083984, :long=> -77.03636932373}, {:name=>"Miami Marlins", :lat=> 25.774269104004, :long=> -80.193656921387}, {:name=>"Arizona Diamondbacks", :lat=> 34.500301361084, :long=> -111.5009765625}, {:name=>"Philadelphia Phillies", :lat=> 39.952331542969, :long=> -75.163787841797}, {:name=>"Chicago Cubs", :lat=> 41.850028991699, :long=> -87.650047302246}, {:name=>"St Louis Cardinals", :lat=> 38.627269744873, :long=> -90.197891235352}, {:name=>"Baltimore Orioles", :lat=> 39.290378570557, :long=> -76.612190246582}, {:name=>"New York Yankees", :lat=> 40.71427154541, :long=> -74.005966186523}, {:name=>"Cincinnati Reds", :lat=> 39.127109527588, :long=> -84.514389038086}, {:name=>"Tampa Bay Rays", :lat=> 27.947519302368, :long=> -82.458427429199}, {:name=>"Texas Rangers", :lat=> 32.735691070557, :long=> -97.108070373535}, {:name=>"Los Angeles Angels", :lat=> 34.052230834961, :long=> -118.24368286133}, {:name=>"Oakland Athletics", :lat=> 37.804370880127, :long=> -122.27079772949}, {:name=>"San Diego Padres", :lat=> 32.715709686279, :long=> -117.16471862793}, {:name=>"New York Mets", :lat=> 40.71427154541, :long=> -74.005966186523}, {:name=>"Houston Astros", :lat=> 29.76328086853, :long=> -95.363273620605}]

    teams.each do |team|
      Team.find_by(name: team[:name]).update_attributes(lat: team[:lat], long: team[:long] )
    end
  end

  def remove_dups user:
    ids = user.picks.select(:event_id).group(:event_id).having("count(*) > 1")
    duplicates = user.picks.where(event_id: ids)
    if duplicates.length == 2
      duplicates.last.destroy
    else
      puts "NOT 2!"
    end
  end
end