require 'csv'

unless Rails.env.production?
  Apartment::Tenant.switch!('budlight')

  account = Account.first
  account.rewards.create(name: "race_to_the_super_bowl", description: "Race to the NFL Super Bowl LIV", category: "Contest", active: false)

  ReferralMilestone.create(name: "1 Referral", description: "When you refer your first friend, you earn 1 entry into a local contest drawing of your choice", level: 1, difficulty: nil, threshold: "1")
  ReferralMilestone.create(name: "5 Referrals", description: "Get to 5 referrals and we'll send you 1 Bud Light bottle opener.", level: 2, difficulty: nil, threshold: "5")
  ReferralMilestone.create(name: "15 Referrals", description: "When you reach to 15 referrals you'll earn a Bud Light T-shirt.", level: 3, difficulty: nil, threshold: "15")
  ReferralMilestone.create(name: "75 Referrals", description: "Make your way all the way up to 75 referrals and we'll give you 2 tickets to an NFL game!", level: 4, difficulty: nil, threshold: "75")


end

