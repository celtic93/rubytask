require 'rails_helper'

feature 'User can create task' do
  given (:client) { create(:user, :client) }
  given (:worker) { create(:user, :worker) }

  describe 'Authenticated client' do
    background do
      sign_in(client)

      visit tasks_path
      click_on 'Create Task'
    end

    scenario 'creates task' do
      fill_in 'task_body', with: 'text text text'
      click_on 'Create Task'

      expect(page).to have_content 'Your task succesfully created.'
      expect(page).to have_content 'text text text'
      expect(page).to have_content client.fullname
    end

    scenario 'creates task with errors', js: true do
      click_on 'Create Task'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'creates task with image' do
      fill_in 'task_body', with: 'text text text'
      attach_file 'Image', "#{Rails.root}/public/apple-touch-icon.png"

      click_on 'Create Task'

      expect(page).to have_css("img")
    end
  end

  scenario 'Authenticated worker tryes to create task' do
    sign_in(worker)
    visit tasks_path

    expect(page).to_not have_link 'Create Task'
  end

  scenario 'Unauthenticated user tryes to create task' do
    visit tasks_path

    expect(page).to_not have_link 'Create Task'
  end
end
