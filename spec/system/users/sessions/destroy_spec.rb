require 'rails_helper'

describe "User's logging out" do
  context 'when user in his personal page and click on the log out button' do
    let(:user) { create(:user) }

    it 'is expected to redirect the user to the log in page and be logged out' do
      logged_as(user)

      visit '/users/me'

      click_link I18n.t('users.show.log_out')

      expect(page.current_path).to eq(new_users_session_path)
      expect(page).to have_content I18n.t('users.sessions.destroy.notice', username: user.username)

      visit '/users/me'

      expect(page.current_path).to eq(new_users_session_path)
      expect(page).to have_content I18n.t('authenticated_area.not_authorized')
    end
  end
end
