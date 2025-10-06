class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[role])
  end

  # catching errors
  rescue_from StandardError, with: :handle_internal_server_error # first to catch latest
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :handle_bad_request
  rescue_from ActionController::BadRequest, with: :handle_bad_request
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def handle_internal_server_error(error)
    logger.error error.backtrace.join("\n")
    render json: { error: error.message }, status: :internal_server_error
  end

  def handle_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def handle_unprocessable_entity(error)
    message = error.record.errors.full_messages.join(", ")
    render json: { error: message }, status: :unprocessable_entity
  end

  def handle_bad_request(error)
    render json: { error: error.message }, status: :bad_request
  end

  def user_not_authorized
    render json: { error: "You not have permission to do this action" }, status: :forbidden
  end
end
