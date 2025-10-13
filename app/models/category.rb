class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name]
  end
end
