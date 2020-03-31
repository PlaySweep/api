class WeeklyUserActivityMailer < ApplicationMailer
  default from: 'ryan@endemiclabs.co'
 
  def stats_email new_users:, returned_users:, left_users:
    @new_users = new_users
    @returned_users = returned_users
    @left_users = left_users
    
    mail(to: 'budweisersweep@endemiclabs.co', subject: "User Feedback Data - #{(DateTime.current).to_date}")
  end
end