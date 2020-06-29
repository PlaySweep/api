class Product < ApplicationRecord
  BASELINE = 100
  has_many :skus
  belongs_to :account
  belongs_to :owner, optional: true
  belongs_to :team, foreign_key: :owner_id, optional: true

  scope :active, -> { where(active: true) }
  scope :filtered, ->(owner_id) { where(owner_id: owner_id) }
  scope :for_category, ->(category) { where(category: category) }

  after_create :create_sku

  def is_digital?
    category == "Digital"
  end

  private

  def sku_code
    code = (self.class.filtered(owner_id).for_category(category).joins(:skus).size + 1) + BASELINE
    owner_id ? "#{owner.account.code_prefix}#{owner.initials.upcase}#{category.first(5).upcase}-#{code}" : "#{owner.account.code_prefix}GLOB#{category.first(5).upcase}-#{code}"
  end

  def create_sku
    skus.create(code: sku_code)
  end

end