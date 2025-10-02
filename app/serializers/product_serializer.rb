class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :created_at, :category

  def category
    {
      name: object.category.name
    }
  end
end
