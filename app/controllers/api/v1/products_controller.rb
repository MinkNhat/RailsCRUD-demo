module Api
  module V1
   class ProductsController < ApplicationController
      def index
        products = Product.all.includes(:category, product_properties: [], images_attachments: :blob)
        render json: products, each_serializer: ProductSerializer
      end

      def show
        product = Product.find(params[:id])
        render json: product, serializer: ProductSerializer
      end
   end
  end
end
