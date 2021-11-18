require 'rails_helper'

describe "User's log in page" do
  context 'when user is logged in' do
    let(:user) { create(:user) }

    it 'is expected to redirect the user to his personal page' do
      logged_as(user)

      visit '/users/sessions/new'

      expect(page.current_path).to eq(user_path('me'))
    end
  end

  context "when user fails to pass the form's validations" do
    let(:user) { create(:user) }

    it 'is expected to not log in the user and return form errors' do
      visit '/users/sessions/new'

      click_button I18n.t('users.sessions.new.log_in')

      within '.user_username' do
        expect(page).to have_content I18n.t('errors.messages.blank')
      end
      within '.user_password' do
        expect(page).to have_content I18n.t('errors.messages.blank')
      end
    end
  end

  context 'when user inputs his credentials correctly' do
    let(:fake_password) { '666' }
    let(:user) { create(:user) }

    it 'is expected to log in the user and redirect the user to his personal page' do
      allow_any_instance_of(User).to receive(:correct_password?) { true }

      visit '/users/sessions/new'

      fill_in User.human_attribute_name(:username), with: user.username
      fill_in User.human_attribute_name(:password), with: fake_password
      click_button I18n.t('users.sessions.new.log_in')

      expect(page.current_path).to eq(user_path('me'))
      expect(page).to have_content I18n.t('users.sessions.create.notice')
    end
  end

  context 'when the user has failed to input his credentials correctly more than User::MAX_LOGIN_FAILURES times,' do
    let(:fake_password) { '666' }
    let(:user) { create(:user) }

    before do
      allow_any_instance_of(User).to receive(:correct_password?) { false }

      visit '/users/sessions/new'

      User::MAX_LOGIN_FAILURES.times do
        fill_in User.human_attribute_name(:username), with: user.username
        fill_in User.human_attribute_name(:password), with: fake_password
        click_button I18n.t('users.sessions.new.log_in')
      end
    end

    context 'and after that he finally inputs the right credentials' do
      it 'is expected for the user not be able to log in because he is locked' do
        allow_any_instance_of(User).to receive(:correct_password?) { true }

        fill_in User.human_attribute_name(:username), with: user.username
        fill_in User.human_attribute_name(:password), with: fake_password
        click_button I18n.t('users.sessions.new.log_in')

        within '.user_username' do
          expect(page).to have_content I18n.t('activemodel.errors.models.user_login_form.attributes.username.locked')
        end
      end
    end
  end
end
