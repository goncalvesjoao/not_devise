# frozen_string_literal: true

require 'rails_helper'

describe UserLoginForm, type: :model do
  describe '#log_in!' do
    context "when username and password are valid but don't match," do
      let(:user) { create(:user, :locked) }
      let(:password) { '666' }
      let(:user_login_form) { described_class.new(username: user.username, password: password) }

      it 'is expected to return false and produce the appropriate errors' do
        allow_any_instance_of(User).to receive(:correct_password?).and_return(false)

        expect_any_instance_of(User).to receive(:log_in!).with(password)

        expect(user_login_form.log_in!).to be false
        expect(user_login_form.errors.where(:username, :invalid)).not_to be_empty
        expect(user_login_form.errors.where(:password, :invalid)).not_to be_empty
      end
    end
  end

  describe '#valid?' do
    context 'when either username or password attributes are blank,' do
      let(:password) { '' }
      let(:user_login_form) { described_class.new(password: password) }

      it 'is expected to return false and produce the appropriate errors' do
        expect(user_login_form.valid?).to be false
        expect(user_login_form.errors.where(:username, :blank)).not_to be_empty
        expect(user_login_form.errors.where(:password, :blank)).not_to be_empty
      end
    end

    context "when password and username are present username doesn't match with an existing User," do
      subject { described_class.new(username: username, password: password).valid? }

      let(:username) { 'john_snow' }
      let(:password) { '666' }

      it { is_expected.to be true }
    end

    context 'and username matches with a locked User and the password is wrong,' do
      let(:user) { create(:user, :locked) }
      let(:password) { '666' }
      let(:user_login_form) { described_class.new(username: user.username, password: password) }

      it 'is expected to return true' do
        allow_any_instance_of(User).to receive(:correct_password?).and_return(false)

        expect(user_login_form.valid?).to be true
      end
    end

    context 'and username matches with a locked User and the password is correct,' do
      let(:user) { create(:user, :locked) }
      let(:password) { '666' }
      let(:user_login_form) { described_class.new(username: user.username, password: password) }

      it 'is expected to return false and produce the appropriate errors' do
        allow_any_instance_of(User).to receive(:correct_password?).and_return(true)

        expect(user_login_form.valid?).to be false
        expect(user_login_form.errors.where(:username, :locked)).not_to be_empty
        expect(user_login_form.errors.where(:password, :blank)).to be_empty
      end
    end
  end

  describe '#user_id' do
    context "when username attribute doesn't match an existing User," do
      let(:username) { 'john_snow' }
      let(:user_login_form) { described_class.new(username: username) }

      it 'is expected to return nil and not make redudant DB calls' do
        expect(User).to receive(:find_by).once.and_call_original

        expect(user_login_form.user_id).to be nil
        expect(user_login_form.user_id).to be nil
      end
    end

    context 'when username attribute does match with an existing User,' do
      let(:user) { create(:user) }
      let(:user_login_form) { described_class.new(username: user.username) }

      it 'is expected to return the id that existing user and not make redudant DB calls' do
        expect(User).to receive(:find_by).once.and_call_original

        expect(user_login_form.user_id).to eq(user.id)
        expect(user_login_form.user_id).to eq(user.id)
      end
    end
  end
end
