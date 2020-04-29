json.id pick.id
json.user_id pick.user_id
json.event pick.event, partial: 'v2/events/event', as: :event
json.selection pick.selection, partial: 'v2/selections/selection', as: :selection