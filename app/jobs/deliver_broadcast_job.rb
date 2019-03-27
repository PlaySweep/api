class DeliverBroadcastJob < ApplicationJob
  @queue = :deliver_broadcast_job

  def perform user_id
    user = BudweiserUser.find(user_id)
    conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
    params = { message_creative_id: user.preference.team.broadcast_message_id, custom_label_id: user.preference.team.broadcast_label_id}
    response = conn.post("broadcast_messages?access_token=#{ENV['ACCESS_TOKEN']}", params)
    broadcast_id = JSON.parse(response.body)["broadcast_id"]
    if broadcast_id
      puts "Broadcast Successful 👍"
    else
      puts "⁉️" 
    end
  end
end