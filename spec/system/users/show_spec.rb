require 'rails_helper'

describe "User's personal page" do
  context 'when user is not logged in' do
    it 'is expected to redirect the user to the log in page' do
      visit '/users/me'

      expect(page.current_path).to eq(new_users_session_path)
      expect(page).to have_content I18n.t('authenticated_area.not_authorized')
    end
  end

  context 'when user is logged in' do
    let(:user) { create(:user) }

    it 'is expected to redirect the user to his personal page' do
      logged_as(user)

      visit "/users/#{user.id}"

      expect(page.current_path).to eq(user_path(user.id))
    end
  end

  context "when user is logged in and is trying to access someone else's page" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'is expected to redirect the user to his personal page' do
      logged_as(user1)

      visit "/users/#{user2.id}"

      expect(page.current_path).to eq(user_path('me'))
      expect(page).to have_content I18n.t('users.show.not_authorized')
    end
  end
end
