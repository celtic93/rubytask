require 'rails_helper'

feature 'User can browse all users' do
  let!(:user1) { create(:user, fullname: 'John Smith') }
  let!(:user2) { create(:user, fullname: 'Konstantin Bykov') }

  scenario 'User visit page with all users' do
    visit users_path

    expect(page).to have_link user1.fullname
    expect(page).to have_link user2.fullname
  end
end
