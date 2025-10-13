module Api
  module V1
    class CategoriesController < ApplicationController
      include Pagy::Backend

      def index
        pagy, categories = pagy(Category.all, limit: params[:size] || Pagy::DEFAULT[:limit])

        render_pagy(
          meta: pagy_metadata(pagy),
          data: categories,
          serializer: CategorySerializer
        )
      end

      def show
        category = Category.find(params[:id])
        render json: category, serializer: CategorySerializer
      end
    end
  end
end
