class User < ApplicationRecord
  MAX_LOGIN_FAILURES = 3

  def correct_password?(password)
    false
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

  private

  def should_user_be_locked?
    login_failure_count >= MAX_LOGIN_FAILURES
  end
end
