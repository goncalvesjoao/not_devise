# frozen_string_literal: true

# More details at: https://robots.thoughtbot.com/activemodel-form-objects

class UserLoginForm
  include ActiveModel::Model
  extend ActiveModel::Translation

  NullUser = Struct.new('NullUser', :id) do
    def locked?
      false
    end

    def log_in!(*)
      false
    end

    def correct_password?(*)
      false
    end
  end

  attr_accessor :username, :password

  validates :username, presence: true
  validates :password, presence: true
  validate :check_if_user_is_locked
  validate :mark_credentials_as_invalid

  delegate :id, to: :user, prefix: true
  delegate :locked?, :log_in!, :correct_password?, to: :user, prefix: true, private: true

  def log_in!
    # Basic validations, to prevent #user_log_in! from being evoke unnecessarily.
    return false if invalid?

    # Same as User#log_in!, changes User#login_failure_count
    # and locks the user according to a successful or failed log in.
    return true if user_log_in!(password)

    # User's password doesn't match User's username, therefore we shall
    # set @mark_credentials_as_invalid to true, so that #valid? method
    # adds :invalid key error to both :username and :password fields.
    @mark_credentials_as_invalid = true

    valid?
  end

  protected

  def user
    @user ||= User.find_by(username: username) || NullUser.new
  end

  def check_if_user_is_locked
    return unless user_correct_password?(password)
    return unless user_locked?

    errors.add(:username, :locked)
  end

  def mark_credentials_as_invalid
    return unless @mark_credentials_as_invalid

    errors.add(:username, :invalid)
    errors.add(:password, :invalid)
  end
end
