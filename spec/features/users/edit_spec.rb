require 'rails_helper'

feature 'User can edit user' do
  given (:client) { create(:user, :client) }
  given (:admin) { create(:user, :admin) }

  describe 'Authenticated admin' do
    background do
      sign_in(admin)
      visit user_path(client)

      expect(page).to have_content 'address'
      expect(page).to_not have_content 'adres'

      click_on 'Edit User'
    end

    scenario 'edits user' do
      fill_in 'Address', with: 'adres'
      click_on 'Update User'

      expect(page).to_not have_content 'address'
      expect(page).to have_content 'adres'
    end

    scenario 'edits user with errors', js: true do
      fill_in 'Address', with: ''
      click_on 'Update User'

      expect(page).to have_content "Address can't be blank"
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(client)
      visit user_path(client)

      expect(page).to have_content 'address'
      expect(page).to_not have_content 'adres'

      click_on 'Edit User'
    end

    scenario 'edits his profile' do
      fill_in 'Address', with: 'adres'
      click_on 'Update User'

      expect(page).to_not have_content 'address'
      expect(page).to have_content 'adres'
    end

    scenario 'edits his profile with errors', js: true do
      fill_in 'Address', with: ''
      click_on 'Update User'

      expect(page).to have_content "Address can't be blank"
    end
  end

  scenario 'Authenticated user tryes to edit other profile' do
    sign_in(client)
    visit user_path(admin)

    expect(page).to_not have_link 'Edit User'
  end

  scenario 'Unauthenticated user tryes to edit user' do
    visit user_path(client)

    expect(page).to_not have_link 'Edit User'
  end
end
