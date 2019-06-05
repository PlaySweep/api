class DataQueries
  def self.active_players_by_picks
    team_ids = Team.active.map(&:id)
    team_ids.each do |team_id|
      User.limit(15).joins(:roles).where('roles.resource_id = ?', team_id).left_joins(:picks).group(:id).order("COUNT(picks.id) DESC").each_with_index do |user, index|
        puts "For #{Team.find(team_id).name}...\n" if index == 0
        puts "#{user.full_name} #{user.email}"
      end
    end
  end
end