class Supervisor::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_supervisor!

  private

  def authorize_supervisor!
    return if current_user.supervisor?

    flash[:alert] = t(".not_authorized")
    redirect_to root_path
  end
end
