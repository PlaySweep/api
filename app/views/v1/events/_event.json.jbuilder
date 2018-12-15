json.id event.id
json.description event.description
json.order event.order
json.selections event.selections.ordered, partial: 'v1/selections/selection', as: :selection