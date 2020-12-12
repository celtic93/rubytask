require 'rails_helper'

feature 'User can edit task' do
  given (:task) { create(:task) }
  given (:client) { task.user }
  given (:worker) { create(:user, :worker) }

  describe 'Authenticated client' do
    background do
      sign_in(client)

      visit task_path(task)
      click_on 'Edit Task'
    end

    scenario 'edits task' do
      expect(page).to have_content 'Body Text'
      expect(page).to_not have_content 'New Task'

      fill_in 'task_body', with: 'New Task'
      click_on 'Update Task'

      expect(page).to_not have_content 'Body Text'
      expect(page).to have_content 'New Task'
    end

    scenario 'edits task with errors', js: true do
      fill_in 'task_body', with: ''
      click_on 'Update Task'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Authenticated worker tryes to edit task' do
    sign_in(worker)
    visit task_path(task)

    expect(page).to_not have_link 'Edit Task'
  end

  scenario 'Unauthenticated user tryes to create task' do
    visit task_path(task)

    expect(page).to_not have_link 'Edit Task'
  end
end
