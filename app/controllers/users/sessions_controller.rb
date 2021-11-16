module Users
  class SessionsController < ApplicationController
    def new
      @user_login_form = UserLoginForm.new
    end

    def create
      @user_login_form = UserLoginForm.new(create_params)

      if @user_login_form.valid_credentials?
        session[:user_id] = @user_login_form.user.id.to_s

        redirect_to root_path, notice: t('.notice', username: @user_login_form.username)
      else
        # If the form's validations pass but the credentials didn't,
        # then it means the password doesn't match the username
        if @user_login_form.valid?
          flash.now[:alert] = t('.alert')
        end

        render :new
      end
    end

    def destroy
    end

    protected

    def create_params
      params.require(:user).permit(:username, :password)
    end
  end
end
