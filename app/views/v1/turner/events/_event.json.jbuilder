json.id event.id
json.description event.description
json.order event.order
json.status event.status
json.winners event.winners, partial: 'v1/turner/selections/selection', as: :selection
json.selections event.selections.ordered, partial: 'v1/turner/selections/selection', as: :selection