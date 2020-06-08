class AuthenticateMessengerUser
  prepend SimpleCommand

  def initialize(facebook_uuid)
    @facebook_uuid = facebook_uuid
  end

  def call
    JsonWebToken.encode(user_id: user.id, registered: user.confirmed) if user
  end

  private

  attr_accessor :facebook_uuid

  def user
    user = User.find_by(facebook_uuid: facebook_uuid)
    return user if user

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end