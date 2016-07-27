class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {
      error: "not_found",
      error_description: "invalid resource id given",
      status: 401
    }, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render json: {
      error: "invalid_request",
      error_description: "request parameter hitting the api are invalid",
      status: 500
    }, status: :invalid_request
  end
end
