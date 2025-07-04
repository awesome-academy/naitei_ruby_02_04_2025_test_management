class Api::V1::ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render json: { error: t("errors.messages.record_not_found") }, status: :not_found
  end

  protected

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
