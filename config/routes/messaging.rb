# api.playsweep.com/v2/messaging/verify?phone_number=4805227771

namespace :messaging, default: { format: :json } do
  get 'verify', to: 'verification#verify'
  get 'verify_check', to: 'verification#verify_check'
  get 'verify_user', to: 'verification#verify_user'
end