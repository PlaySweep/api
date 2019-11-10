class WeeklyAnalyticsJob < ApplicationJob
    queue_as :low
  
    def perform
      number_of_playing_promotions_used_by_week
      DataMailer.weekly_playing_promotions(email: "ben@endemiclabs.co").deliver_later
      number_of_sweep_promotions_used_by_week
      DataMailer.weekly_sweep_promotions(email: "ben@endemiclabs.co").deliver_later
    end
  
    def number_of_playing_promotions_used_by_week
      promotions = Promotion.where(type: "DrizlyPromotion", used: true, category: "Playing").where('updated_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 7, DateTime.current.end_of_day) 
      promotions.each do |promotion|
        CSV.open("#{Rails.root}/tmp/playing_promotions.csv", "wb") do |csv|
          csv << ["Type", "Code"]
          csv << [promotion.category, promotion.level]
        end
      end
    end
  
    def number_of_playing_promotions_used_all_time level:
      promotions = Promotion.where(type: "DrizlyPromotion", used: true, category: "Playing", level: level) 
      promotions.size
    end
  
    def number_of_sweep_promotions_used_by_week
      slates = Slate.finished.where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - 5, DateTime.current.end_of_day) 
      promotions = Promotion.where(type: "DrizlyPromotion", category: "Sweep", used: true, level: level).joins(:slate).where('slates.id IN (?)', slates.map(&:id))
      promotions.each do |promotion|
        CSV.open("#{Rails.root}/tmp/sweep_promotions_by_week.csv", "wb") do |csv|
          csv << ["Type", "Code"]
          csv << [promotion.category, promotion.level]
        end
      end
    end
  
    def number_of_sweep_promotions_used_all_time level:
      slates = Slate.finished
      promotions = Promotion.where(type: "DrizlyPromotion", category: "Sweep", used: true, level: level).joins(:slate).where('slates.id IN (?)', slates.map(&:id))
      promotions.size
    end
  
  end