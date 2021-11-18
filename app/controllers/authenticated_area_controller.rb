# frozen_string_literal: true

class AuthenticatedAreaController < ApplicationController
  before_action :authenticate_user!

  protected

  def authenticate_user!
    return if current_user.present?

    redirect_to new_users_session_path, alert: t('authenticated_area.not_authorized')
  end
end
