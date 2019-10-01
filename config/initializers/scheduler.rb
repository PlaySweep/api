require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

if Rails.env.production?

  scheduler.cron '0 12 * * *' do
    AnalyticsJob.perform_later
  end

end
