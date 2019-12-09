require 'csv'

unless Rails.env.production?
  Apartment::Tenant.switch!('budlight')


  milestone1 = ReferralMilestone.create(name: "1 Referral", description: "When you refer your first friend, you automatically earn 1 entry into the next contest you enter. Kind of like an Automatic Sweep!", level: 1, difficulty: nil, threshold: "1")
  milestone2 = ReferralMilestone.create(name: "5 Referrals", description: "Hit 5 referrals and we’ll send you your own Bud Light bottle opener.", level: 2, difficulty: nil, threshold: "5")
  milestone3 = ReferralMilestone.create(name: "15 Referrals", description: "Hit 15 referrals and we’ll send you a Bud Light T-Shirt.", level: 3, difficulty: nil, threshold: "15")
  milestone4 = ReferralMilestone.create(name: "75 Referrals", description: "Hit 75 referrals and we’ll send you 2 tickets to a 2019 NFL regular season game (travel not included).", level: 4, difficulty: nil, threshold: "75")


end

