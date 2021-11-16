# See more in: https://robots.thoughtbot.com/activemodel-form-objects

class UserLoginForm
  include ActiveModel::Model
  extend ActiveModel::Translation

  attr_accessor :username
  attr_accessor :password

  validates_presence_of :username
  validates_presence_of :password

  def valid_credentials?
    valid?
  end
end
