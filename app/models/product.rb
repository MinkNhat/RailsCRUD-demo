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
  validates :name, :price, presence: true
  validates :name, length: { maximum: 50 }
  validates :price, numericality: true, comparison: { greater_than: 0 }
  validates :name, product_name_start_with_sp: true
end
