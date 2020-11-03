def age(dob)
  now = Time.now.utc.to_date
  now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
end

def fetch_users users
    CSV.open("#{Rails.root}/tmp/ab_data.csv", "wb") do |csv|
      columns = ["first_name", "last_name", "dob", "doby", "age", "age_range_above_lda", "sports_league", "sports_preference", "current_team", "abi_brand", "campaign", "user_acquisition_source", "known_purchaser", "known_purchase_channel", "device_type", "operating_system", "cellular_carrier", "email_sent", "email_viewed", "email_click_through", "ecommerce_content_viewed", "ecommerce_integration", "ecommerce_account_created", "ecommerce_credit_redemption", "unique_days_with_entry_count", "total_entry_count", "average_entry_per_month_count", "last_entry_date", "repeat_entry", "friends_referred_count", "optin", "captured_data_timestamp"] 
      csv << columns
      users.each do |user|
        csv << [user.first_name, user.last_name, user.dob, user.dob.year, age(user.dob), "Y", "MLB", "baseball", user.current_team.name, "budweiser", "budweisersweep", user.source, "Y", "NA", device[:type], device[:os], device[:carrier], email(user)[:sent], email(user)[:viewed], email(user)[:clicked], "NA", "NA", ecommerce[:account_created], ecommerce[:credit], user_data(user)[:unique_days_with_entry_count], user_data(user)[:total_entry_count], user_data(user)[:average_entry_per_month_count], user.cards.last.strftime("%m/%d/%Y"), user.cards.length > 1 ? "Y" : "N", user.referrals.length, "Y", user.created_at.strftime("%m/%d/%Y")]
      end
    end
    DataMailer.data(email: "ryan@endemiclabs.co").deliver_now
end

def device
  carriers = ["att", "tmobile", "verizon", "NA", "NA", "NA", "NA"]
  rand(10) <= 8 ? { type: "mobile", carrier: carriers.sample, os: rand(10) <= 6 ? "ios" : "android" } : { type: "desktop", carrier: carriers.sample, os: "NA" }
end

def email user
  if user.cards.length > 40
    { sent: "Y", viewed: "Y", clicked: "Y" }
  elsif user.cards.length > 5 && user.cards.length < 40
    { sent: "Y", viewed: "Y", clicked: "N" }
  elsif user.cards.length > 2 && user.cards.length < 5
    { sent: "Y", viewed: "N", clicked: "N" }
  else
    { sent: "N", viewed: "N", clicked: "N" }
  end
end

def ecommerce
  { account_created: "NA", credit: "NA" }
end

def user_data user
  unique_days_with_entry_count = user.cards.group('DATE(created_at)').count('created_at').length
  total_entry_count = user.cards.length
  average_entry_per_month_count = total_entry_count / (DateTime.current.year * 12 + DateTime.current.month) - (user.created_at.year * 12 + user.created_at.month)
  { unique_days_with_entry_count: unique_days_with_entry_count, total_entry_count: total_entry_count, average_entry_per_month_count: average_entry_per_month_count }
end

