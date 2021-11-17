# More details at: https://robots.thoughtbot.com/activemodel-form-objects

class UserLoginForm
  include ActiveModel::Model
  extend ActiveModel::Translation

  NullUser = Struct.new('NullUser', :id) do
    def locked?; false; end
    def user_log_in!(*); false; end
    def correct_password?(*); false; end
  end

  attr_accessor :username
  attr_accessor :password

  validates_presence_of :username
  validates_presence_of :password
  validate :validate_user_locked

  delegate :id, to: :user, prefix: true
  delegate :locked?, :user_log_in!, :correct_password?, to: :user, prefix: true, private: true

  def log_in!
    valid? && user_log_in!(password)
  end

  protected

  def user
    @user ||= User.find_by(username: username) || NullUser.new
  end

  def validate_user_locked
    return unless user_correct_password?(password)
    return unless user_locked?

    errors.add(:username, :locked)
  end
end
