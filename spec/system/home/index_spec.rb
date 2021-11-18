# frozen_string_literal: true

require 'rails_helper'

describe 'Home page' do
  context 'when user is not logged in' do
    it 'is expected to redirect the user to the log in page' do
      visit '/'

      expect(page).to have_current_path(new_users_session_path, ignore_query: true)
    end
  end

  context 'when user is logged in' do
    let(:user) { create(:user) }

    it 'is expected to redirect the user to his personal page' do
      logged_as(user)

      visit '/'

      expect(page).to have_current_path(user_path('me'), ignore_query: true)
    end
  end
end
