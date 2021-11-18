FactoryBot.define do
  factory :user do
    sequence(:username, 1) { |n| "fakeuser_#{'0' if n < 10}#{n}" }

    trait :login_failed_one_attempt_left do
      login_failure_count { User::MAX_LOGIN_FAILURES - 1 }
      locked_at { nil }
    end

    trait :locked do
      login_failure_count { User::MAX_LOGIN_FAILURES }
      locked_at { Time.now }
    end
  end
end
