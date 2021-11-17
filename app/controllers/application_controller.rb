class ApplicationController < ActionController::Base
  def current_user
    # Preventing making extra DB calls in case @current_user is set to nil
    return @current_user if defined?(@current_user)

    @current_user = session[:user_id].present? ? User.find(session[:user_id]) : nil
  end
  helper_method :current_user

  protected

  def raise_not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
