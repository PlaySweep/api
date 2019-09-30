class SelectWinnerJob < ApplicationJob
  @queue = :select_winner_job

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    find_winner(slate) unless slate.done?
  end

  def find_winner slate
    previous_user_ids = slate.previous_user_ids || []
    winner_collection = slate.cards.win - previous_user_ids
    loser_collection = slate.cards.loss - previous_user_ids
    found_a_winner = false

    if previous_user_ids.size >= 2
      slate.update_attributes(winner_id: 1)
    else
      until found_a_winner
        if winner_collection.any?
          user_id = winner_collection.sample.user_id
          previous_user_ids.push(user_id)
          slate.update_attributes(winner_id: user_id, previous_user_ids: previous_user_ids)
          found_a_winner = true
        else
          user_id = loser_collection.sample.user_id
          previous_user_ids.push(user_id)
          slate.update_attributes(winner_id: user_id, previous_user_ids: previous_user_ids)
          found_a_winner = true
        end
      end
    end
    
  end
end