# custom validator
class ProductNameStartWithSpValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.start_with?("SP_")
      record.errors.add(attribute, "Ten san pham phai bat dau bang SP_")
    end
  end
end


class Product < ApplicationRecord
  belongs_to :category
  has_many :product_images, -> { order(:position) }, dependent: :destroy # -> { order(:position) } scope sắp xếp position
  has_many :product_properties, dependent: :destroy, reject_if: :reject_properties

  # nested attributes --> cho phép tạo / sửa model con qua model cha
  accepts_nested_attributes_for :product_properties, allow_destroy: true
  accepts_nested_attributes_for :product_images, allow_destroy: true

  validates :name, :price, presence: true
  validates :name, length: { maximum: 50 }
  validates :price, numericality: true, comparison: { greater_than: 0 }
  validates :name, product_name_start_with_sp: true

  def reject_properties(property)
    property[:key].blank?
  end
end
