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

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_with @user
  end

  private

  def user_params
    params.require(:user).permit(:id, :confirmed, :active)
  end
end