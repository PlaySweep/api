class WeeklyUserActivityMailer < ApplicationMailer
  default from: 'ryan@endemiclabs.co'
 
  def stats_email new_users:, returned_users:, left_users:, message_count:, can_users:, confirmed_can_users:, registered_count:, unregistered_count:, phone_number_count:
    @new_users = new_users
    @returned_users = returned_users
    @left_users = left_users
    @message_count = message_count
    @can_users = can_users
    @confirmed_can_users = confirmed_can_users
    @registered_count = registered_count
    @unregistered_count = unregistered_count
    @phone_number_count = phone_number_count
    
    mail(to: 'ryan@endemiclabs.co', subject: "User Feedback Data - #{(DateTime.current).to_date}")
  end
end