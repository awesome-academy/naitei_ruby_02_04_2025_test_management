class ApplicationController < ActionController::Base
  include Pagy::Backend
  layout :layout_by_resource
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:alert] = t("errors.messages.record_not_found")
    redirect_to request.referer || root_path
  end

  def default_url_options
    {locale: params[:locale] || I18n.default_locale}
  end

  protected

  def configure_permitted_parameters
    added_attrs = User::EXTRA_USER_ATTR
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def layout_by_resource
    if devise_controller?
      "devise_layout"
    else
      "application"
    end
  end

  def after_sign_in_path_for(resource)
    if resource.supervisor?
      supervisor_subjects_path
    else
      subjects_path
    end
  end
end
