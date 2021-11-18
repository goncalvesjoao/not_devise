require 'rails_helper'

describe User, type: :model do
  describe '.create' do
    context 'given a blank password, ' do
      let(:user) { described_class.create(username: 'john_snow', password: '') }

      it 'is expected to not save the user to the DB and produce the appropriate errors' do
        expect(user.id).to be_nil
        expect(user.errors.where(:password, :blank)).to_not be_empty
      end
    end

    context 'given a password smaller than User::MIN_PASSWORD_LENGTH, ' do
      let(:user) { described_class.create(username: 'john_snow', password: '666') }

      it 'is expected to not save the user to the DB and produce the appropriate errors' do
        expect(user.id).to be_nil
        expect(user.errors.where(:password, :too_short)).to_not be_empty
      end
    end
  end

  describe '#valid?' do
    context 'when user is a new record,' do
      context 'and has a blank username' do
        let(:user) { build(:user, username: '') }

        it 'is expected to return false and produce the appropriate errors' do
          expect(user.valid?).to be false
          expect(user.errors.where(:username, :blank)).to_not be_empty
        end
      end

      context 'and his username is not unique' do
        let(:user1) { create(:user) }
        let(:user2) { build(:user, username: user1.username) }

        it 'is expected to return false and produce the appropriate errors' do
          expect(user2.valid?).to be false
          expect(user2.errors.where(:username, :taken)).to_not be_empty
        end
      end
    end

    context 'when user is an existing record,' do
      context 'and his username is set to blank' do
        let(:user) { create(:user).tap { |user| user.username = '' } }

        it 'is expected to return false and produce the appropriate errors' do
          expect(user.valid?).to be false
          expect(user.errors.where(:username, :blank)).to_not be_empty
        end
      end

      context "and his username is set to another user's username" do
        let(:user1) { create(:user) }
        let(:user2) { create(:user).tap { |user| user.username = user1.username } }

        it 'is expected to return false and produce the appropriate errors' do
          expect(user2.valid?).to be false
          expect(user2.errors.where(:username, :taken)).to_not be_empty
        end
      end
    end
  end

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
