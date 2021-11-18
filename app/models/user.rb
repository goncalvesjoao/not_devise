class User < ApplicationRecord
  MIN_PASSWORD_LENGTH = 8
  MAX_LOGIN_FAILURES = 3
  PASSWORD_COST = 12 # Let's make the hashing function take a while to process to make the hacker's life dificult

  validates_presence_of :username
  validates_uniqueness_of :username
  validate :validate_password, on: :create

  def password
    @password ||= password_hash.present? ? BCrypt::Password.new(password_hash) : nil
  end

  def password=(new_password)
    @password_length = new_password.length
    @password = BCrypt::Password.create(new_password, cost: PASSWORD_COST)

    self.password_hash = @password
  end

  def correct_password?(guest_password)
    password == guest_password
  end

  def log_in!(password)
    return false if locked?

    reset_login_failure_count! and return true if correct_password?(password)

    increment_login_failure_count! and return false
  end

  def locked?
    locked_at.present?
  end

  protected

  def reset_login_failure_count!
    update(login_failure_count: 0, locked_at: nil)
  end

  def increment_login_failure_count!
    self.login_failure_count += 1
    self.locked_at = Time.now if should_user_be_locked?

    save
  end

  def validate_password
    if !@password_length || @password_length.zero?
      return errors.add(:password, :blank)
    end

    if @password_length < MIN_PASSWORD_LENGTH
      errors.add(:password, :too_short, count: @password_length)
    end
  end

  private

  def should_user_be_locked?
    login_failure_count >= MAX_LOGIN_FAILURES
  end
end
