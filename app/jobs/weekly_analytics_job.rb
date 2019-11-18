class WeeklyAnalyticsJob < ApplicationJob
    queue_as :low
  
    def perform
      number_of_promotions_used_by_week
      DataMailer.weekly_promotions(email: "ben@endemiclabs.co").deliver_later
      number_of_sweep_promotions_used_by_week
      DataMailer.weekly_sweep_promotions(email: "ben@endemiclabs.co").deliver_later
    end
  
    def number_of_promotions_used_by_week
      promotions = Promotion.where(type: "DrizlyPromotion", used: true).where('updated_at BETWEEN ? AND ?', DateTime.current.beginning_of_day - 9, DateTime.current.end_of_day - 3) 
      CSV.open("#{Rails.root}/tmp/number_of_promotions.csv", "wb") do |csv|
        csv << ["Type", "Level"]
        promotions.each do |promotion|
          if promotion.category == "Playing"
            case promotion.level
            when 1
              level = "$5"
            when 2
              level = "$10"
            end
          end

          if promotion.category == "Sweep"
            case promotion.level
            when 1
              level = "$20"
            end
          end
          csv << [promotion.category, level]
        end
      end
    end
  
    def number_of_playing_promotions_used_all_time level:
      promotions = Promotion.where(type: "DrizlyPromotion", used: true, category: "Playing", level: level) 
      promotions.size
    end
  
    def number_of_sweep_promotions_used_by_week from:
      slates = Slate.finished.where('start_time BETWEEN ? AND ?', DateTime.current.beginning_of_day - from, DateTime.current.end_of_day) 
      promotions = Promotion.where(type: "DrizlyPromotion", category: "Sweep", used: true).joins(:slate).where('slates.id IN (?)', slates.map(&:id))
      CSV.open("#{Rails.root}/tmp/sweep_promotions.csv", "wb") do |csv|
        csv << ["User ID", "Category", "Level", "Name"]
        promotions.each do |promotion|
          csv << [promotion.user.id, promotion.category, promotion.level, promotion.user.full_name]
        end
      end
    end
  
    def number_of_sweep_promotions_used_all_time level:
      slates = Slate.finished
      promotions = Promotion.where(type: "DrizlyPromotion", category: "Sweep", used: true, level: level).joins(:slate).where('slates.id IN (?)', slates.map(&:id))
      promotions.size
    end
  
  end