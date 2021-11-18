module Users
  class SessionsController < ApplicationController
    def index
      # This action is enabled to avoid the route '/users/sessions'
      # to translate to '/users/:id' in wich the id would be 'sessions'
      raise_not_found
    end

    def new
      redirect_to(user_path('me')) and return if current_user

      @user_login_form = UserLoginForm.new
    end

    def create
      @user_login_form = UserLoginForm.new(create_params)

      if @user_login_form.log_in!
        session[:user_id] = @user_login_form.user_id

        redirect_to user_path('me'), notice: t('.notice')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      # current_user needs to load before session loses the :user_id key
      flash[:warning] = t('.notice', username: current_user.username)

      session.delete(:user_id)

      redirect_to root_path
    end

    protected

    def create_params
      params.require(:user).permit(:username, :password)
    end
  end
end
