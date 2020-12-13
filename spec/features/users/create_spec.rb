require 'rails_helper'

feature 'Admin can create user' do
  given (:client) { create(:user, :client) }
  given (:admin) { create(:user, :admin) }

  describe 'Authenticated admin' do
    background do
      sign_in(admin)

      visit users_path
      click_on 'Create User'
    end

    scenario 'creates user' do
      fill_in 'Email', with: 'user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      fill_in 'Login', with: 'Gantver'
      fill_in 'Fullname', with: 'Sasha Rakitin'
      fill_in 'Birthday', with: '01/01/1980'
      fill_in 'Address', with: 'Lenina 3'
      fill_in 'City', with: 'Moscow'
      fill_in 'State', with: 'State'
      fill_in 'Country', with: 'Russia'
      fill_in 'Zip', with: '234566'

      click_on 'Create User'

      expect(page).to have_content  'user@test.com'
      expect(page).to have_content 'Gantver'
      expect(page).to have_content 'Sasha Rakitin'
      expect(page).to have_content '1980-01-01 00:00:00 UTC'
      expect(page).to have_content 'Lenina 3'
      expect(page).to have_content 'Moscow'
      expect(page).to have_content 'State'
      expect(page).to have_content 'Russia'
      expect(page).to have_content '234566'
    end

    scenario 'creates user with errors', js: true do
      click_on 'Create User'
      
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
      expect(page).to have_content "Login can't be blank"
      expect(page).to have_content "Fullname can't be blank"
      expect(page).to have_content "Birthday can't be blank"
      expect(page).to have_content "Address can't be blank"
      expect(page).to have_content "City can't be blank"
      expect(page).to have_content "State can't be blank"
      expect(page).to have_content "Country can't be blank"
      expect(page).to have_content "Zip can't be blank"
    end
  end

  scenario 'Authenticated worker tryes to create user' do
    sign_in(client)
    visit users_path

    expect(page).to_not have_link 'Create User'
  end

  scenario 'Unauthenticated user tryes to create user' do
    visit users_path

    expect(page).to_not have_link 'Create User'
  end
end
