module Api
  module V1
    module Admin
      class CategoriesController < Api::V1::Admin::BaseController
        def index
          authorize Category
          categories = Category.all
          render json: categories, each_serializer: ::Admin::CategorySerializer
        end

        def show
          authorize Category
          category = Category.find(params[:id])
          render json: category, serializer: ::Admin::CategorySerializer
        end

        def create
          authorize Category
          category = Category.create!(category_params)
          render json: category, serializer: ::Admin::CategorySerializer, status: :created
        end

        def update
          authorize Category
          category = Category.find(params[:id])
          category.update!(category_params)
          render json: category, serializer: ::Admin::CategorySerializer
        end

        def destroy
          authorize Category
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
