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

  def self.remove_jsonb
    Apartment::Tenant.switch!('budweiser')
    Slate.all.each do |slate|
      data = slate.data.reject {|k| k == "prizing_category" }
      slate.update_attributes(data: data)
    end
  end
end