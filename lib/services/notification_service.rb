class NotificationService
  def initialize user
    @user = user
  end

  def run type: 
    case type
    when :playing
      for_playing
    end
  end

  # def sweep_reward_active?
  #   @user.account.rewards.active.find_by(name: "Drizly", category: "Sweep").present?
  # end

  def for_playing
    if @user.played_for_first_time?
      if @user.facebook_uuid?
        first_time_playing_message = @user.account.copies.active.where(category: "Initial Pick Confirmation").sample.message
        interpolated_first_time_playing_message = first_time_playing_message % { first_name: @user.first_name }
        quick_replies = FacebookParser::QuickReplyObject.new([
          {
            content_type: :text,
            title: "Play again",
            payload: "PLAY"
          },
          {
            content_type: :text,
            title: "Share",
            payload: "SHARE"
          }
        ]).objects
        FacebookMessaging::Standard.deliver(
          user: @user, 
          message: interpolated_first_time_playing_message, 
          quick_replies: quick_replies,
          notification_type: "NO_PUSH"
        )
      else
        # TODO Send an SMS verification text for first time play
        client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])
        service = client.notify.v1.services(ENV["TWILIO_NOTIFY_#{@user.account.app_name.upcase.gsub(' ', '_')}_SERVICE_ID"])
        copy = @user.account.copies.find_by(category: "SMS Welcome")
        if copy.present?
          notification = service.notifications.create(
            to_binding: { binding_type: 'sms', address: "+#{@user.phone_number.try(:number)}"}.to_json,
            body: copy.message
          )
        end
      end
    end
  end
end