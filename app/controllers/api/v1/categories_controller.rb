module Api
  module V1
    class CategoriesController < ApplicationController
      skip_before_action :authorized, only: [ :index, :show, :products ]
      before_action :authorize_admin, only: [ :create, :update, :destroy ]

      def index
        categories = Category.all
        render json: categories
      end

      def show
        category = Category.find(params[:id])
        render json: category
      end

      def create
        category = Category.new(category_params)
        if category.save
          render json: category, status: :created
        else
          render json: category.errors, status: :unprocessable_entity
        end
      end

      def update
        category = Category.find(params[:id])
        if category.update(category_params)
          render json: category
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
        render json: products
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
