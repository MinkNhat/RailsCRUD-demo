module Api
  module V1
    module Admin
      class BaseController < ApplicationController
        # before_action :authenticate_admin!

        # def authenticate_admin!
        #   authenticate_user!
        #   unless current_user&.admin?
        #     render json: { error: "You not have permission to do..." }, status: :forbidden
        #   end
        # end
      end
    end
  end
end
