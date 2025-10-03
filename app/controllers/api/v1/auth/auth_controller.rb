module Api
  module V1
    module Auth
      class AuthController < ApplicationController
        skip_before_action :authorized, only: [ :login, :signup ]
        before_action :authorize_admin, only: [ :create_admin ]

        def login
          user = User.find_by(email: params[:email])
          if user&.authenticate(params[:password])
            token = encode_token(user_id: user.id)
            render json: {
              user: UserSerializer.new(user),
              token: token
            }
          else
            render json: { message: "Invalid email or password" }, status: :unauthorized
          end
        end

        def signup
          if params[:role] == 1 || params[:role] == "admin"
            render json: {
              message: "Cannot create admin user"
            }, status: :forbidden
            return
          end

          user = User.new(user_params)
          user.role = "user"
          if user.save
            token = encode_token(user_id: user.id)
            render json: {
              user: UserSerializer.new(user),
              token: token
            }, status: :created
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def create_admin
          user = User.new(user_params)
          user.role = "admin"

          if user.save
            render json: {
              user: UserSerializer.new(user),
              message: "Admin created successfully"
            }, status: :created
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def user_params
          params.permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end
