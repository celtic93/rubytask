require 'rails_helper'

feature 'User can create comments' do
  given (:task) { create(:task) }
  given (:client) { task.user }
  given (:admin) { create(:user, :admin) }

  describe 'Authenticated user' do
    background do
      sign_in(client)
      visit task_path(task)
    end

    scenario 'comments a task', js: true do
      fill_in 'Comment', with: 'Comment text'
      click_on 'Create Comment'

      within ".comments" do
        expect(page).to have_content "Comment text"
        expect(page).to have_content client.fullname
      end
    end

    scenario 'comments a task with errors', js: true do
      click_on 'Create Comment'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Authenticated admin tryes to comment a task' do
    sign_in(admin)
    visit task_path(task)
    expect(page).to_not have_button 'Create Comment'
  end

  scenario 'Unauthenticated user tryes to comment a task' do
    visit task_path(task)
    expect(page).to_not have_button 'Create Comment'
  end
end
