class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :category, :images, :properties,

  def properties
    object.product_properties.map { |p| { id: p.id, key: p.key, value: p.value } }
  end

  def images
    object.images.map do |img|
      {
        id: img.id,
        url: Rails.application.routes.url_helpers.rails_blob_url(img),
        position: img.position
      }
    end
  end

  def category
    {
      name: object.category.name
    }
  end
end
