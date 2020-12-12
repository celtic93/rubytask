require 'rails_helper'

feature 'User can edit comment' do
  given(:task) { create(:task) }
  given(:client) { task.user }
  given(:admin) { create(:user, :admin) }
  given!(:comment) { create(:comment, user: client, task: task) }

  describe 'Authenticated user tryes to edit' do
    scenario 'his comment', js: true do
      sign_in(client)
      visit task_path(task)

      within '.comments' do
        expect(page).to have_content 'Comment Body Text'
        expect(page).to_not have_content 'edited comment'
        expect(page).to_not have_selector 'textarea'

        click_on 'Edit'
        expect(page).to have_selector 'textarea'

        fill_in 'comment[body]', with: 'edited comment'
        click_on 'Update Comment'

        expect(page).to_not have_content 'Comment Body Text'
        expect(page).to have_content 'edited comment'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'his comment with errors', js: true do
      sign_in(client)
      visit task_path(task)

      within '.comments' do
        click_on 'Edit'

        fill_in 'comment[body]', with: ''
        click_on 'Update Comment'
        
        expect(page).to have_content 'Comment Body Text'
        expect(page).to have_selector 'textarea'
        expect(page).to have_content "Body can't be blank"
      end 
    end

    scenario "someone else's comment" do
      sign_in(admin)
      visit task_path(task)

      within '.comments' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user tryes to edit comment' do
    visit task_path(task)

    within '.comments' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
