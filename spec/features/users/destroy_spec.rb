require 'rails_helper'

feature 'User can delete user' do
  given (:user) { create(:user, :client) }
  given (:admin) { create(:user, :admin) }

  scenario 'Admin tryes to delete user' do
    sign_in(admin)
    visit user_path(user)

    click_on 'Delete User'
    expect(page).to have_content 'User succesfully deleted.'
  end

  scenario 'User tryes to delete someone else' do
    sign_in(user)
    visit user_path(user)

    expect(page).to_not have_link 'Delete User'
  end

  scenario 'Unauthenticated user tryes to delete user' do
    visit user_path(user)

    expect(page).to_not have_link 'Delete User'
  end
end
