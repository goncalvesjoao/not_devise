require 'rails_helper'

describe User, type: :model do
  describe '#locked?' do
    context 'when the user.locked_at is nil' do
      subject { create(:user) }

      it 'must return false' do
        expect(subject.locked?).to be false
      end
    end

    context 'when the user.locked_at as a date' do
      subject { create(:user, locked_at: Time.now) }

      it 'must return true' do
        expect(subject.locked?).to be true
      end
    end
  end

  describe '#verify_password!' do
    context 'when the user password is valid and the user is not locked' do
      let(:user) { create(:user, :login_failed_one_attempt_left) }
      let(:password) { '123' }

      it 'must return true and reset the login_failure_count' do
        allow(user).to receive(:verify_password) { true }

        expect(user.verify_password!(password)).to be true

        expect(user.login_failure_count).to be 0
        expect(user.locked_at).to be nil
      end
    end

    context 'when the user password is valid and the user is locked' do
      let(:user) { create(:user, :locked) }
      let(:password) { '123' }

      it 'must return false and not change login_failure_count' do
        allow(user).to receive(:verify_password) { false }

        expect(user.verify_password!(password)).to be false

        expect(user.login_failure_count).to be User::MAX_LOGIN_FAILURES
        expect(user.locked_at).to_not be nil
      end
    end

    context 'when the user password is invalid' do
      let(:user) { create(:user) }
      let(:password) { '123' }

      it 'must return false and increment the login_failure_count' do
        allow(user).to receive(:verify_password) { false }

        expect(user.verify_password!(password)).to be false

        expect(user.login_failure_count).to be 1
        expect(user.locked_at).to be nil
      end
    end

    context 'when the user password is invalid and user only has one login_failure attempt' do
      let(:user) { create(:user, :login_failed_one_attempt_left) }
      let(:password) { '123' }

      it 'must return false, increment the login_failure_count and populate locked_at' do
        allow(user).to receive(:verify_password) { false }

        expect(user.verify_password!(password)).to be false

        expect(user.login_failure_count).to be User::MAX_LOGIN_FAILURES
        expect(user.locked_at).to_not be nil
      end
    end

    context 'when the user password is invalid and user is locked' do
      let(:user) { create(:user, :locked) }
      let(:password) { '123' }

      it 'must return false and not increment login_failure_count' do
        allow(user).to receive(:verify_password) { false }

        expect(user.verify_password!(password)).to be false

        expect(user.login_failure_count).to be User::MAX_LOGIN_FAILURES
        expect(user.locked_at).to_not be nil
      end
    end
  end
end
