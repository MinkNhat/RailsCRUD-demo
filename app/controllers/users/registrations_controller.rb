class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: UserSerializer.new(current_user).serializable_hash, status: :created
    else
      render json: {
        message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"
      }, status: :unprocessable_entity
    end
  end
end
