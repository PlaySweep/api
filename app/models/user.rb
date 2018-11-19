class User < ApplicationRecord

  has_many :sweeps
  has_many :picks
  has_many :events, through: :picks
  has_many :cards
  has_many :slates, through: :cards

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def self.by_name full_name
    full_name = full_name.split(' ')
    find_by_first_name_and_last_name(full_name[0], full_name[-1])
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def rank
    1
  end

  # def is_protected?
  #   streak % 4 == 3 && items.available_protectors.any?
  # end

end