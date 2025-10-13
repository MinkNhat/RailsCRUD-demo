module Api
  module V1
    module Admin
      class ProductsController < Api::V1::Admin::BaseController
        include Pagy::Backend

        before_action :simplify_params_key, only: [ :create, :update ]

        def index
          authorize Product
          pagy, products = pagy(Product.all.includes(:category, product_properties: [], images_attachments: :blob))

          render_pagy(
            meta: pagy_metadata(pagy),
            data: products,
            serializer: ::Admin::ProductSerializer
          )
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

          handle_duplicate_key(product)
          product.update!(product_params.except(:images))

          # xoá ảnh nếu có yêu cầu
          if params[:remove_image].present?
            product.images_attachments.where(id: params[:remove_image]).destroy_all
          end

          # attach thêm ảnh, không xoá ảnh cũ
          if params[:images].present?
            product.images.attach(params[:images])
          end

          render json: product, serializer: ::Admin::ProductSerializer
        end

        def destroy
          authorize Product
          product = Product.find(params[:id])
          product.destroy
          head :no_content
        end

        def move_image
          product = Product.find(params[:id])

          image = product.images_attachments.find_by(position: params[:old_position].to_i)
          return render json: { error: "Not found image in position #{params[:old_position].to_i}" }, status: :not_found unless image

          image.insert_at(params[:new_position].to_i)

          render json: product, serializer: ::Admin::ProductSerializer
        end

        private

        def product_params
          params.permit(
            :name, :price, :category_id, images: [],
            product_properties_attributes: [ :id, :key, :value, :_destroy ]
          )
        end

        def simplify_params_key
          # nhận params từ client có key properties thay vì product_properties_attributes
          # gán key sau đó xoá tránh trùng key
          if params[:properties]
            params[:product_properties_attributes] = params.delete(:properties)
          end
        end

        def handle_duplicate_key(product)
          props_params = params[:product_properties_attributes]
          return unless props_params.present?

          req_keys = props_params.map { |p| p[:key] }
          product.product_properties.where(key: req_keys).destroy_all
        end
      end
    end
  end
end
