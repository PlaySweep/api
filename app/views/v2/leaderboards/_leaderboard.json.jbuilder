json.top_scorers leaderboard.top(10, { with_member_data: true })
json.rank leaderboard.rank_for(current_user.id).to_i || 0
json.score leaderboard.score_for(current_user.id).to_i || 0
json.ordinal_position leaderboard.rank_for(current_user.id).to_i.ordinalize.last(2)
json.tied leaderboard.total_members_in_score_range(leaderboard.score_for(current_user.id).to_i, leaderboard.score_for(current_user.id).to_i) > 1.0