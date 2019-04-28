class BroadcastTarget < ApplicationRecord
  belongs_to :targetable, polymorphic: true
end