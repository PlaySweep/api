# api.playsweep.com/v2/messaging/verify

namespace :messaging, default: { format: :json } do
  get 'verify', to: 'twilio#verify'
  get 'verify_check', to: 'twilio#verify_check'
end