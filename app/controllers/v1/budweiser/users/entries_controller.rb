class V1::Budweiser::Users::EntriesController < BudweiserController
  respond_to :json

  def create
    @entry = current_user.entries.create!
    # TODO Send notice to user that they've referred a friend
    respond_with @entry
  end

end