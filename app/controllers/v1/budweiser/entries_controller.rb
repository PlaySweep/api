class V1::Budweiser::EntriesController < BudweiserController
  respond_to :json


  def create
    @entry = current_user.entries.create(entry_params)
    if params[:user_joined_uuid]
      puts "🍌" * 25
      puts "Your friend #{User.find_by(facebook_uuid: params[:user_joined_uuid])}"
      puts "🍌" * 25
    end
    if @entry.save
      respond_with @entry
    else
      render json: { errors: @entry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:used)
  end
end