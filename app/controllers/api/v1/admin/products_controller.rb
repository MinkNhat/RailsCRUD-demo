module Api
  module V1
    module Admin
      class ProductsController < Api::V1::Admin::BaseController
           before_action :simplify_params_key, only: [ :create, :update ]

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
            params.require(:product).permit(
              :name, :price, :category_id,
              product_images_attributes: [ :id, :image, :position, :_destroy ],
              product_properties_attributes: [ :id, :key, :value, :_destroy ]
            )
          end

          def simplify_params_key
            # nhận params từ client có key images/properties thay vì product_images_attributes/product_properties_attributes
            # gán key sau đó xoá tránh trùng key
            if params[:product][:images]
              params[:product][:product_images_attributes] = params[:product].delete(:images)
            end

            if params[:product][:properties]
              params[:product][:product_properties_attributes] = params[:product].delete(:properties)
            end
          end
      end
    end
  end
end
