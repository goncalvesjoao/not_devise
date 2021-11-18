require 'rails_helper'

describe "Sessions Index page" do
  it 'is expected to return 404' do
    visit '/users/sessions'

    expect(page.status_code).to eq(404)
  end
end
