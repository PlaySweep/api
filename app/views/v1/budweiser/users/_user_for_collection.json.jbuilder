json.cache! ["user/#{user.id}/#{user.updated_at}", user], expires_in: 5.minutes do
  json.id user.id
  json.facebook_uuid user.facebook_uuid
  json.first_name user.first_name
  json.last_name user.last_name
  json.full_name user.full_name
  json.handle user.handle
  json.confirmed user.confirmed
  json.locked user.locked
end