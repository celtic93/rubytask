require 'rails_helper'

feature 'User can sign up' do
  background { visit new_user_registration_path }

  describe 'User tryes to sign up with' do
    background do
      fill_in 'Email', with: 'user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Login', with: 'Gantver'
      fill_in 'Fullname', with: 'Sasha Rakitin'
      fill_in 'Birthday', with: '01/01/1980'
      fill_in 'Address', with: 'Lenina 3'
      fill_in 'City', with: 'Moscow'
      fill_in 'State', with: 'Russia'
      fill_in 'Country', with: 'Russia'
      fill_in 'Zip', with: '234566'
    end

    scenario 'valid attributes' do
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'mismatched passwords' do
      fill_in 'Password confirmation', with: '12345679'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  scenario 'User tryes to sign up with invalid attributes' do
    click_on 'Sign up'

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
