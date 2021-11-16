module Users
  class SessionsController < ApplicationController
    def new
      @user_login_form = UserLoginForm.new
    end

    def create
    end

    def destroy
    end
  end
end
