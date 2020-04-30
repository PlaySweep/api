# api.playsweep.com/v2/messaging/verify

namespace :messaging, default: { format: :json } do
  get 'verify', to: 'verification#verify'
  get 'verify_check', to: 'verification#verify_check'
end