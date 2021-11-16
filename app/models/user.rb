class User < ApplicationRecord
  MAX_LOGIN_FAILURES = 3

  def verify_password(password)
    false
  end

  def verify_password!(password)
    return false if locked?

    reset_login_failure_count! and return true if verify_password(password)

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

    if login_failure_count >= MAX_LOGIN_FAILURES
      self.locked_at = Time.now
    end

    save
  end
end
