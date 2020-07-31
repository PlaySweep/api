class Standing < ApplicationRecord
  belongs_to :owner
  belongs_to :team, foreign_key: :owner_id

  scope :ordered, -> { order(league: :asc) }

  after_update :update_associated_event_details

  private

  def update_associated_event_details
    if saved_change_to_records?
      associated_slates = Slate.filtered(owner_id).editable
      associated_slates.each do |slate|
        last_event = slate.events.ordered.last
        last_event.update_attributes(
          details: "The #{owner.abbreviation} are #{records} this season."
        ) if last_event.category_is_outcome?
      end
    end
  end
end