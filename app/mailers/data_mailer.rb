class DataMailer < ApplicationMailer
  default from: "ryan@endemiclabs.co"

  def engagement_analytics_for day:, email:
    account = Account.first
    engagement_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_engagement_data.csv")
    attachments["#{(DateTime.current - day).to_date}_engagement_data.csv"] = { mime_type: 'text/csv', content: engagement_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Engagement Analytics - #{(DateTime.current - day).to_date}",
      body: "Attached below."
    )
  end

  def user_acquisition_for day:, email:
    account = Account.first
    acquistion_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_new_users.csv")
    attachments["#{(DateTime.current - day).to_date}_new_users.csv"] = { mime_type: 'text/csv', content: acquistion_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} User Acquisition - #{(DateTime.current - day).to_date}",
      body: "Attached below."
    )
  end

  def drizly email:
    account = Account.first
    drizly_winners_csv = File.read("#{Rails.root}/tmp/drizly_winners.csv")
    attachments["drizly_winners.csv"] = { mime_type: 'text/csv', content: drizly_winners_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Drizly Winners",
      body: "Attached below."
    )
  end

  def contest_leaderboard email:
    account = Account.first
    world_series_leaderboard_csv = File.read("#{Rails.root}/tmp/world_series_leaderboard.csv")
    attachments["world_series_leaderboard.csv"] = { mime_type: 'text/csv', content: world_series_leaderboard_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} World Series Leaderboard",
      body: "Attached below."
    )
  end

  def weekly_promotions email:
    account = Account.first
    number_of_promotions = File.read("#{Rails.root}/tmp/number_of_promotions.csv")
    attachments["number_of_promotions.csv"] = { mime_type: 'text/csv', content: number_of_promotions }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Number of Promotions",
      body: "Attached below."
    )
  end

  def weekly_sweep_promotions email:
    account = Account.first
    sweep_promotions = File.read("#{Rails.root}/tmp/sweep_promotions.csv")
    attachments["sweep_promotions.csv"] = { mime_type: 'text/csv', content: sweep_promotions }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Sweep Promotion User List",
      body: "Attached below."
    )
  end

  def users team:, email:
    account = Account.first
    team_players = File.read("#{Rails.root}/tmp/#{team.abbreviation.downcase}_players.csv")
    attachments["#{team.abbreviation.downcase}_players.csv"] = { mime_type: 'text/csv', content: team_players }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} #{team.abbreviation} Players",
      body: "Attached below."
    )
  end

  def acquistion day:, email:
    account = Account.first
    acquistion_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_acquisition_data.csv")
    attachments["#{(DateTime.current - day).to_date}_acquistion_data.csv"] = { mime_type: 'text/csv', content: acquistion_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Acquistion - #{(DateTime.current - day).to_date}",
      body: "Attached below."
    )
  end

  def engagement day:, email:
    account = Account.first
    engagement_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_engagement_data.csv")
    attachments["#{(DateTime.current - day).to_date}_engagement_data.csv"] = { mime_type: 'text/csv', content: engagement_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Engagement - #{(DateTime.current - day).to_date}",
      body: "Attached below."
    )
  end

  def engagement email:
    account = Account.first
    engagement_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current).to_date}_engagement_data.csv")
    attachments["#{(DateTime.current).to_date}_engagement_data.csv"] = { mime_type: 'text/csv', content: engagement_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Engagement - #{(DateTime.current).to_date}",
      body: "Attached below."
    )
  end

  def skus email:
    account = Account.first
    skus_csv = File.read("#{Rails.root}/tmp/#{DateTime.current.to_date}_skus.csv")
    attachments["#{Rails.root}/tmp/#{DateTime.current.to_date}_skus.csv"] = { mime_type: 'text/csv', content: skus_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Skus CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def products email:
    account = Account.first
    products_csv = File.read("#{Rails.root}/tmp/products.csv")
    attachments["#{Rails.root}/tmp/products.csv"] = { mime_type: 'text/csv', content: products_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Products CSV",
      body: "Attached below."
    )
  end

  def lookalike_audience email:
    account = Account.first
    lookalike_audience_csv = File.read("#{Rails.root}/tmp/lookalike_audience.csv")
    attachments["#{Rails.root}/tmp/lookalike_audience.csv"] = { mime_type: 'text/csv', content: lookalike_audience_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Lookalike Audience CSV",
      body: "Attached below."
    )
  end

  def prizes email:
    account = Account.first
    prizes_csv = File.read("#{Rails.root}/tmp/prizes.csv")
    attachments["#{Rails.root}/tmp/prizes.csv"] = { mime_type: 'text/csv', content: prizes_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Prizes CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def teams email:
    account = Account.first
    teams_csv = File.read("#{Rails.root}/tmp/teams.csv")
    attachments["#{Rails.root}/tmp/teams.csv"] = { mime_type: 'text/csv', content: teams_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Teams CSV",
      body: "Attached below."
    )
  end

  def slates email:
    account = Account.first
    slates_csv = File.read("#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_slates.csv")
    attachments["#{Rails.root}/tmp/#{(DateTime.current - day).to_date}_slates.csv"] = { mime_type: 'text/csv', content: slates_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Slates CSV #{(DateTime.current - day).to_date}",
      body: "Attached below."
    )
  end

  def all_orders_to email:
    account = Account.first
    orders_csv = File.read("#{Rails.root}/tmp/orders.csv")
    attachments["#{Rails.root}/tmp/orders.csv"] = { mime_type: 'text/csv', content: orders_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Orders CSV #{(DateTime.current).to_date}",
      body: "Attached below."
    )
  end

  def selections_to email:
    account = Account.first
    selections_csv = File.read("#{Rails.root}/tmp/selections.csv")
    attachments["#{Rails.root}/tmp/selections.csv"] = { mime_type: 'text/csv', content: selections_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Selections CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def orders_to email:
    account = Account.first
    orders_csv = File.read("#{Rails.root}/tmp/#{DateTime.current.to_date}_orders.csv")
    attachments["#{Rails.root}/tmp/#{DateTime.current.to_date}_orders.csv"] = { mime_type: 'text/csv', content: orders_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Orders CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end  
  
  def data email:
    account = Account.first
    ab_data = File.read("#{Rails.root}/tmp/ab_data.csv")
    attachments["#{Rails.root}/tmp/ab_data.csv"] = { mime_type: 'text/csv', content: ab_data }
    mail(
      to: email,
      subject: "AB Data",
      body: "Attached below."
    )
  end

  def send_contacts_list email:
    account = Account.first
    contacts_list_csv = File.read("#{Rails.root}/tmp/email_contact_list.csv")
    attachments["#{Rails.root}/tmp/email_contact_list.csv"] = { mime_type: 'text/csv', content: contacts_list_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Contacts List CSV",
      body: "Attached below."
    )
  end

  def gopuff_to email:
    account = Account.first
    gopuff_csv = File.read("#{Rails.root}/tmp/#{DateTime.current.to_date}_gopuff.csv")
    attachments["#{Rails.root}/tmp/#{DateTime.current.to_date}_gopuff.csv"] = { mime_type: 'text/csv', content: gopuff_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} GoPuff Users CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def winners_to email:
    account = Account.first
    winners_csv = File.read("#{Rails.root}/tmp/#{DateTime.current.to_date}_winners.csv")
    attachments["#{Rails.root}/tmp/#{DateTime.current.to_date}_winners.csv"] = { mime_type: 'text/csv', content: winners_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Winners CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def losers_to email:
    account = Account.first
    losers_csv = File.read("#{Rails.root}/tmp/#{DateTime.current.to_date}_losers.csv")
    attachments["#{Rails.root}/tmp/#{DateTime.current.to_date}_losers.csv"] = { mime_type: 'text/csv', content: losers_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Losers CSV #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def lookalike_audience email:
    account = Account.first
    lookalike_audience_csv = File.read("#{Rails.root}/tmp/lookalike_audience.csv")
    attachments["#{Rails.root}/tmp/lookalike_audience.csv"] = { mime_type: 'text/csv', content: lookalike_audience_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Lookalike Audience #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end

  def users email:
    account = Account.first
    users_csv = File.read("#{Rails.root}/tmp/users.csv")
    attachments["#{Rails.root}/tmp/users.csv"] = { mime_type: 'text/csv', content: users_csv }
    mail(
      to: email,
      subject: "#{account.friendly_name} #{account.name} Users #{DateTime.current.to_date}",
      body: "Attached below."
    )
  end
end
