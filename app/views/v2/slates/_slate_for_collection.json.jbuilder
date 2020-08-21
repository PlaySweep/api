json.id slate.id
json.name slate.name
json.type slate.type
json.description slate.description
json.event_size slate.events.size
json.status slate.status
json.start_time slate.start_time
json.is_contest slate.contest_id?
json.contest slate.contest, partial: 'v2/contests/contest', as: :contest
json.result slate.result
json.score slate.score
json.total_sweeps slate.cards.win.size
json.total_entries slate.cards.size
json.event_size slate.events.size
json.number_of_correct_answers slate.number_of_correct_answers_for(current_user.id)
json.played slate.played?(current_user.id)
json.winner slate.winner, partial: 'v2/users/user_for_member', as: :user
json.has_winner slate.has_winner?
json.previous_user_ids slate.previous_user_ids
json.prize do
  json.id slate.prize.id
  json.product do 
    json.id slate.prize.product.id
    json.name slate.prize.product.name
    json.size slate.prize.sku.try(:size)
    json.category slate.prize.product.category
  end
  json.date slate.prize.date
end
json.label "In-game"
json.owner_image slate.owner.image if slate.owner
json.participants slate.participants.ordered.each do |participant|
  json.id participant.id
  json.field participant.field
  json.team participant.team, partial: 'v2/teams/team', as: :team
  json.profile participant.player.try(:profile), partial: 'v2/profiles/profile', as: :profile
end