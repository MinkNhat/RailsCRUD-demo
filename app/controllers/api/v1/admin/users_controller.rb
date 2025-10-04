module Api
  module V1
    module Admin
      class UsersController < Api::V1::Admin::BaseController
        def create
          user = User.create!(admin_user_params)
          render json: user, serializer: UserSerializer, status: :created
        end

        def admin_user_params
          params.require(:user).permit(:email, :password, :password_confirmation, :role)
        end
      end
    end
  end
end
