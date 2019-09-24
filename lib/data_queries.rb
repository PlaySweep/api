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

  def promotions_earned_by_week weeks_back:
    promotions = Promotion.joins(:slate).where('slates.start_time BETWEEN ? AND ?', (DateTime.current.beginning_of_week - weeks_back.week) + 3, (DateTime.current.end_of_week - weeks_back.week) + 1)
    { five: promotions.where(level: [0, 1]).count, ten: promotions.where(level: [2]).count, total: promotions.count }
  end
end