module Api
  module V1
   class ProductsController < ApplicationController
      include Pagy::Backend

      def index
        pagy, products = pagy(Product.all.includes(:category, product_properties: [], images_attachments: :blob), limit: params[:size] || Pagy::DEFAULT[:limit])

        render_pagy(
          meta: pagy_metadata(pagy),
          data: products,
          serializer: ProductSerializer
        )
      end

      def show
        product = Product.find(params[:id])
        render json: product, serializer: ProductSerializer
      end
   end
  end
end
