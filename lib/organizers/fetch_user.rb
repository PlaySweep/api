class FetchUser
  extend LightService::Organizer

  def self.call(params)
    with(params: params).reduce(
      FindUserById,
      FindUserByFacebookId
    )
  end
end

class FindUserById
  extend ::LightService::Action
  expects :params

  executed do |context|
    unless context.params[:id].nil?
      User.find_by(id: context.params[:id])
    end
  end
end

class FindUserByFacebookId
  extend ::LightService::Action
  expects :params

  executed do |context|
    unless context.params[:facebook_uuid].nil?
      User.find_by(facebook_uuid: context.params[:facebook_uuid])
    end
  end
end