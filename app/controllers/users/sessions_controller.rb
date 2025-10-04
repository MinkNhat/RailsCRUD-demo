class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    render json: UserSerializer.new(current_user).serializable_hash
  end

  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last, ENV["JWT_SECRET"]).first
      current_user = User.find_by(id: jwt_payload["sub"], jti: jwt_payload["jti"])
    end

    if current_user
      render json: "Logged out successfully"
    else
      render json: {
        message: "Couldn't find an active session"
      }, status: :unauthorized
    end
  end
end
