class SelectWinnerJob < BudweiserJob
  @queue = :select_winner_job

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    find_winner(slate)
  end

  def find_winner slate
    winner_collection = slate.cards.win - slate.previous_user_ids
    loser_collection = slate.cards.loss - slate.previous_user_ids
    found_a_winner = false

    until found_a_winner
      if winner_collection.any?
        user_id = winner_collection.sample.user_id
        slate.previous_user_ids.push(user_id)
        slate.update_attributes(winner_id: user_id, previous_user_ids: slate.previous_user_ids)
        puts "Found #{User.find(user_id).inspect} in winning cards"
        found_a_winner = true
      else
        user_id = loser_collection.sample.user_id
        slate.previous_user_ids.push(user_id)
        slate.update_attributes(winner_id: user_id, previous_user_ids: slate.previous_user_ids)
        puts "Found #{User.find(user_id).inspect} in losing cards"
        found_a_winner = true
      end
    end
    
  end
end