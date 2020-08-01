class V2::Admin::SelectionsController < BasicAuthenticationController
  respond_to :json

  def update
    @selection = Selection.find(params[:id])
    @selection.update_attributes(selection_params)
    respond_with @selection
  end

  private

  def selection_params
    params.require(:selection).permit(:id, :status)
  end
end