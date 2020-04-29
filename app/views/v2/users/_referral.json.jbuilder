json.id referral.id
json.first_name referral.first_name
json.last_name referral.last_name
json.confirmed referral.confirmed
json.played referral.has_played?
json.nudge referral.nudged.today
json.nudged referral.nudged.today.present?
json.percentage referral.confirmed && referral.has_played? ? 100 : referral.confirmed && !referral.has_played? ? 50 : 0