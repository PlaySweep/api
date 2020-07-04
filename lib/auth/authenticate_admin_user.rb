class AuthenticateAdminUser
  prepend SimpleCommand

  def initialize(id)
    @id = id
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :id

  def user
    user = Admin.find_by(id: id)
    return user if user

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
