class UsersController < AuthenticatedAreaController
  before_action :find_user, only: %i(show)

  def show
    if @user != current_user
      redirect_to user_path('me'), alert: t('.not_authorized')
    end
  end

  protected

  def find_user
    @user = params[:id] == 'me' ? current_user : User.find(params[:id])
  end
end
