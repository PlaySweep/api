class Product < ApplicationRecord
  BASELINE = 100
  has_many :skus
  belongs_to :team, foreign_key: :owner_id, optional: true

  scope :active, -> { where(active: true) }
  scope :filtered, ->(owner_id) { where(owner_id: owner_id) }
  scope :for_category, ->(category) { where(category: category) }

  after_create :create_sku

  private

  def sku_code
    code = self.class.filtered(owner_id).for_category(category).size + BASELINE
    if global?
      code = Product.where(global: true).for_category(category).size + BASELINE
      "GLOB#{category.first(5).upcase}-#{code}"
    else
      code = self.class.filtered(owner_id).for_category(category).size + BASELINE
      "#{team.initials}#{category.first(5).upcase}-#{code}"
    end
  end

  def create_sku
    skus.create(code: sku_code)
  end

end