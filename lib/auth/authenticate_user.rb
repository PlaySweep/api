class AuthenticateUser
  prepend SimpleCommand

  def initialize(phone_number)
    @phone_number = phone_number
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :phone_number

  def user
    pn = PhoneNumber.find_by(number: phone_number)
    return pn.user if pn

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end