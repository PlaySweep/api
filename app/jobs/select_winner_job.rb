class SelectWinnerJob < ApplicationJob
  queue_as :high

  def perform slate_id
    slate = Slate.find_by(id: slate_id)
    find_winner(slate) unless slate.done?
  end

  def find_winner slate
    previous_user_ids = slate.previous_user_ids || []
    winner_collection = slate.cards.win - previous_user_ids
    loser_collection = slate.cards.loss - previous_user_ids
    found_a_winner = false

    if slate.ticket_prizing?
      winner_collection = winner_collection.select { |card| card.user.eligible_for_prize?(slate: slate) }
      loser_collection = loser_collection.select { |card| card.user.eligible_for_prize?(slate: slate) }
    end

    if winner_collection.empty?
      Popcorn.notify("4805227771", "No eligible winners for slate: #{slate.id}")
    elsif loser_collection.empty?
      Popcorn.notify("4805227771", "No eligible losers for slate: #{slate.id}")
    end

    if previous_user_ids.size >= 2
      slate.update_attributes(winner_id: 1)
    else
      until found_a_winner
        if winner_collection.any?
          user_id = winner_collection.sample.user_id
          previous_user_ids.push(user_id)
          slate.update_attributes(winner_id: user_id, previous_user_ids: previous_user_ids)
          found_a_winner = true
        elsif loser_collection.any?
          user_id = loser_collection.sample.user_id
          previous_user_ids.push(user_id)
          slate.update_attributes(winner_id: user_id, previous_user_ids: previous_user_ids)
          found_a_winner = true
        else
          Popcorn.notify("4805227771", "No one eligible for slate: #{slate.id}")
          found_a_winner = true
        end
      end
    end
    
  end
end