class DataMigration
  def self.preference_to_roles
    Apartment::Tenant.switch!('budweiser')
    Team.active.each do |team|
      User.joins(:preference).where("preferences.data->>'owner_id' = :owner_id", owner_id: team.id.to_s).each do |user|
        user.add_role team.name.downcase.split(' ').join('_').to_sym, team
        print "Switched #{user.first_name} to #{team.name} using Roles."
      end
    end
    puts "All done."
  end
end