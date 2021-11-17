class HomeController < ApplicationController
  def index
    redirect_to current_user ? user_path('me') : new_users_session_path
  end
end
