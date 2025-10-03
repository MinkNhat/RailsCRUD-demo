class ApplicationController < ActionController::API
  before_action :authorized

  SECRET_KEY = ENV["JWT_SECRET"]

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decoded_token
    header = request.headers["Authorization"]
    if header
      token = header.split(" ")[1]
      begin
        JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @user = User.find_by(id: user_id)
    end
  end

  def authorized
    render json: { message: "Please log in" }, status: :unauthorized unless current_user
  end

  def authorize_admin
    render json: { message: "Admin access required" }, status: :forbidden unless current_user&.admin?
  end
end
