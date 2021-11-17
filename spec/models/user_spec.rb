require 'rails_helper'

describe User, type: :model do
  describe '#locked?' do
    context 'when the user.locked_at is populated with nil,' do
      subject { build(:user).locked? }

      it { is_expected.to be false }
    end

    context 'when the user.locked_at is populated with a date,' do
      subject { build(:user, locked_at: Time.now).locked? }

      it { is_expected.to be true }
    end
  end

  describe '#log_in!' do
    context 'when the user password is valid and the user is not yet locked,' do
      let(:user) { create(:user, :login_failed_one_attempt_left) }
      let(:password) { '666' }

      it 'is expected to return true and reset the login_failure_count' do
        allow(user).to receive(:correct_password?) { true }

        expect(user.log_in!(password)).to be true
        expect(user.login_failure_count).to be 0
        expect(user.locked_at).to be nil
      end
    end

    context 'when the user password is valid and the user is locked,' do
      let(:user) { create(:user, :locked) }
      let(:password) { '666' }

      it 'is expected to return false and not change login_failure_count' do
        allow(user).to receive(:correct_password?) { false }

        expect(user.log_in!(password)).to be false
        expect(user.login_failure_count).to be User::MAX_LOGIN_FAILURES
        expect(user.locked_at).to_not be nil
      end
    end

    context 'when the user password is invalid,' do
      let(:user) { create(:user) }
      let(:password) { '666' }

      it 'is expected to return false and increment the login_failure_count' do
        allow(user).to receive(:correct_password?) { false }

        expect(user.log_in!(password)).to be false
        expect(user.login_failure_count).to be 1
        expect(user.locked_at).to be nil
      end
    end

    context 'when the user password is invalid and user only has one login failure attempt left,' do
      let(:user) { create(:user, :login_failed_one_attempt_left) }
      let(:password) { '666' }

      it 'is expected to return false, increment the login_failure_count and populate locked_at' do
        allow(user).to receive(:correct_password?) { false }

        expect(user.log_in!(password)).to be false
        expect(user.login_failure_count).to be User::MAX_LOGIN_FAILURES
        expect(user.locked_at).to_not be nil
      end
    end

    context 'when the user password is invalid and user is locked,' do
      let(:user) { create(:user, :locked) }
      let(:password) { '666' }

      it 'is expected to return false and not increment login_failure_count' do
        allow(user).to receive(:correct_password?) { false }

        expect(user.log_in!(password)).to be false
        expect(user.login_failure_count).to be User::MAX_LOGIN_FAILURES
        expect(user.locked_at).to_not be nil
      end
    end
  end
end
