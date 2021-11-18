require 'rails_helper'

describe 'Home page' do
  context 'when user is not logged in' do
    it 'is expected to redirect the user to the log in page' do
      visit '/'

      expect(page.current_path).to eq(new_users_session_path)
    end
  end

  context 'when user is logged in' do
    let(:user) { create(:user) }

    it 'is expected to redirect the user to his personal page' do
      logged_as(user)

      visit '/'

      expect(page.current_path).to eq(user_path('me'))
    end
  end
end
