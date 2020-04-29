json.id event.id
json.description event.description
json.details event.details
json.order event.order
json.status event.status
json.winners event.winners, partial: 'v2/selections/selection', as: :selection
json.selections event.selections.ordered, partial: 'v2/selections/selection', as: :selection