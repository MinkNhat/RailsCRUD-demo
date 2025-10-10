class ProductImage < ApplicationRecord
  belongs_to :product
  has_one_attached :image

  before_create :set_position

  def set_position
    if self.position.nil?
      max_position = product.product_images.maximum(:position) || 0
      self.position = max_position + 1
    end
  end
end
