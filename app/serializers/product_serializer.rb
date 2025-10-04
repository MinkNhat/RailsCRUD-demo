class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :category

  def category
    {
      name: object.category.name
    }
  end
end
