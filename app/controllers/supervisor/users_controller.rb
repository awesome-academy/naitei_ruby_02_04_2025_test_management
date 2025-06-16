class Supervisor::UsersController < Supervisor::BaseController
  load_and_authorize_resource

  def index
    users_scope = User.user.latest

    if params[:query].present?
      users_scope = users_scope.search_by_name_or_email(params[:query])
    end

    @pagy, @users = pagy users_scope
    @search_query = params[:query]
  end

  def show; end

  def toggle_active
    if @user.toggle!(:active)
      flash[:notice] = t(".success")
    else
      flash[:alert] = t(".error")
    end
    redirect_to supervisor_users_path
  end
end
