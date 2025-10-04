module Api
  module V1
    module Admin
      class ProductsController < Api::V1::Admin::BaseController
          def index
            products = Product.all
            render json: products, each_serializer: ::Admin::ProductSerializer
          end

          def show
            product = Product.find(params[:id])
            render json: product, serializer: ::Admin::ProductSerializer
          end

          def create
            product = Product.new(product_params)
            if product.save
              render json: product, serializer: ::Admin::ProductSerializer, status: :created
            else
              render json: product.errors, status: :unprocessable_entity
            end
          end

          def update
            product = Product.find(params[:id])
            if product.update(product_params)
              render json: product, serializer: ::Admin::ProductSerializer
            else
              render json: product.errors, status: :unprocessable_entity
            end
          end

          def destroy
            product = Product.find(params[:id])
            product.destroy
            head :no_content
          end

          private

          def product_params
            params.require(:product).permit(:name, :price, :category_id)
          end
      end
    end
  end
end
