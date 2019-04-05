namespace :migrate do
  desc "Migrate Preferences to Roles"
  task preference_to_roles: :environment do
    teams = Team.active
    ActiveRecord::Base.transaction do
      Apartment::Tenant.switch!('budweiser')
      teams.each do |team|
        user.add_role team.name, team
        print "Switched #{user.name} to #{team.name} using Roles."
      end
    end

    puts " All done now!"
  end
end