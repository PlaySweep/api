json.id pick.id
json.user_id pick.user_id
json.event pick.event, partial: 'v1/budweiser/events/event', as: :event
json.selection pick.selection, partial: 'v1/budweiser/selections/selection', as: :selection