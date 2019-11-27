class ReferralMilestone < Achievement
  START_DATE = DateTime.new(2019, 12, 1)
  KLASS = "ReferralMilestone"

  jsonb_accessor :data,
    difficulty: [:string, default: nil]

end