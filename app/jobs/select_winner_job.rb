class SelectWinnerJob < ApplicationJob
  queue_as :high

  def perform resource_id, resource_type
    resource = resource_type.constantize.find_by(id: resource_id)
    if resource_type == "Slate"
      find_winner_for_slate(resource) unless resource.done? 
    end
    if resource_type == "Quiz"
      find_winner_for_quiz(resource) unless resource.pending?
    end
  end

  def find_winner_for_slate slate
    previous_user_ids = slate.previous_user_ids || []
    winner_collection = slate.cards.win - previous_user_ids
    loser_collection = slate.cards.loss - previous_user_ids
    found_a_winner = false

    if slate.ticket_prizing?
      winner_collection = winner_collection.select { |card| card.user.eligible_for_prize?(slate: slate) }
      loser_collection = loser_collection.select { |card| card.user.eligible_for_prize?(slate: slate) }
    end
    winner_collection = winner_collection.select { |card| card.user.eligible_to_win? }
    loser_collection = loser_collection.reject { |card| Order.find_by(user_id: card.user_id) }

    if previous_user_ids.size >= 2
      found_a_winner = true
    else
      until found_a_winner
        if winner_collection.any?
          user_id = winner_collection.sample.user_id
          previous_user_ids.push(user_id)
          slate.update_attributes(current_winner_id: user_id, previous_user_ids: previous_user_ids)
          found_a_winner = true
        elsif loser_collection.any?
          user_id = loser_collection.sample.user_id
          previous_user_ids.push(user_id)
          slate.update_attributes(current_winner_id: user_id, previous_user_ids: previous_user_ids)
          found_a_winner = true
        else
          found_a_winner = true
        end
      end
    end
    
  end

  def find_winner_for_quiz quiz
    winner_collection = quiz.cards.win
    loser_collection = quiz.cards.loss
    found_a_winner = false

    winner_collection = winner_collection.select { |card| card.user.eligible_to_win? }
    loser_collection = loser_collection.reject { |card| Order.find_by(user_id: card.user_id) }

    until found_a_winner
      if winner_collection.any?
        user_id = winner_collection.sample.user_id
        quiz.update_attributes(current_winner_id: user_id)
        found_a_winner = true
      elsif loser_collection.any?
        user_id = loser_collection.sample.user_id
        quiz.update_attributes(current_winner_id: user_id)
        found_a_winner = true
      else
        found_a_winner = true
      end
    end
    
  end
end