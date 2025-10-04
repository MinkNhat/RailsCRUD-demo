class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  # alway user role when signup
  def sign_up_params
    user_params = params.require(:user).permit(:email, :password)
    user_params[:role] = "user"
    user_params
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: UserSerializer.new(resource).serializable_hash, status: :created
    else
      render json: {
        message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
      }, status: :unprocessable_entity
    end
  end
end
