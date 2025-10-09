module Api
  module V1
    module Admin
      class ProductsController < Api::V1::Admin::BaseController
          def index
            authorize Product
            products = Product.all.includes(:category, product_images: { image_attachment: :blob })
            render json: products, each_serializer: ::Admin::ProductSerializer
          end

          def show
            authorize Product
            product = Product.find(params[:id])
            render json: product, serializer: ::Admin::ProductSerializer
          end

          def create
            authorize Product
            product = Product.create!(product_params)

            # create images
            Array(params[:product][:product_images]).each_with_index do |image, index|
              product.product_images.create(image: image, position: index)
            end
            render json: product, serializer: ::Admin::ProductSerializer, status: :created
          end

          def update
            authorize Product
            product = Product.find(params[:id])
            product.update!(product_params)
            render json: product, serializer: ::Admin::ProductSerializer
          end

          def destroy
            authorize Product
            product = Product.find(params[:id])
            product.destroy
            head :no_content
          end

          private

          def product_params
            params.require(:product).permit(:name, :price, :category_id, images: [])
          end
      end
    end
  end
end
