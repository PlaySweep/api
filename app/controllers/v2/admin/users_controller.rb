class V2::Admin::UsersController < BasicAuthenticationController
  respond_to :json

  def index
    @users = User.for_admin
    respond_with @users
  end

  def show
    @user = User.find(params[:id])
    respond_with @user
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    if params[:clear_out]
      @user.cards.destroy_all
      @user.picks.destroy_all
      @user.choices.destroy_all
      role = @user.roles.find_by(resource_type: "Team")
      if role
        symbolized_role = role.resource.name.downcase.split(' ').join('_').to_sym
        @user.remove_role(symbolized_role, role.resource)
      end
    end
    if @user.save
      respond_with @user
    else
      render json: { errors: [] }, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_with @user
  end

  private

  def user_params
    params.require(:user).permit(:id, :confirmed, :active, :dob, :zipcode)
  end
end