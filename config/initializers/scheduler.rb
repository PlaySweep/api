require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

if Rails.env.production?

  scheduler.cron '05 16 * * *' do
    AnalyticsJob.perform_later
  end

end
