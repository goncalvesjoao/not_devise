# See more in: https://robots.thoughtbot.com/activemodel-form-objects

class UserLoginForm
  include ActiveModel::Model
  extend ActiveModel::Translation

  attr_accessor :username
  attr_accessor :password

  validates_presence_of :username
  validates_presence_of :password

  def valid_credentials?
    return false unless valid?
    return false unless user

    user.password == password
  end

  def user
    # Preventing making extra DB calls in case @user is attributed with nil
    return @user if defined?(@user)

    @user = User.find_by_username(username)
  end
end
