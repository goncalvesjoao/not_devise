class HomeController < ApplicationController
  def index
    # Comment this redirect to enable your landing page
    redirect_to new_users_sessions_path
  end
end
