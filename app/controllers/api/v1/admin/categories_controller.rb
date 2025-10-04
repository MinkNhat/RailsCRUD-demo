module Api
  module V1
    module Admin
      class CategoriesController < Api::V1::Admin::BaseController
        def index
          categories = Category.all
          render json: categories, each_serializer: ::Admin::CategorySerializer
        end

        def show
          category = Category.find(params[:id])
          render json: category, serializer: ::Admin::CategorySerializer
        end

        def create
          category = Category.new(category_params)
          if category.save
            render json: category, serializer: ::Admin::CategorySerializer, status: :created
          else
            render json: category.errors, status: :unprocessable_entity
          end
        end

        def update
          category = Category.find(params[:id])
          if category.update(category_params)
            render json: category, serializer: ::Admin::CategorySerializer
          else
            render json: category, status: :unprocessable_entity
          end
        end

        def destroy
          category = Category.find(params[:id])
          category.destroy
          head :no_content
        end

        def products
          products = Product.where(category_id: params[:id])
          render json: products, each_serializer: ::Admin::AdminCategorySerializer
        end

        private

        def category_params
          params.require(:category).permit(:name)
        end
      end
    end
  end
end
