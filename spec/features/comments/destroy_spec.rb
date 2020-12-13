require 'rails_helper'

feature 'User can delete comment' do
  let(:task) { create(:task) }
  let(:client) { task.user }
  let(:worker) { create(:user, :worker) }
  let(:admin) { create(:user, :admin) }
  let!(:comment) { create(:comment, user: client, task: task) }

  describe 'Authenticated user tryes to delete comment' do
    scenario 'his comment', js: true do
      sign_in(client)
      visit task_path(task)

      within "#comment_#{comment.id}" do
        expect(page).to have_content 'Comment Body Text'

        click_on 'Delete'
        expect(page).to have_content 'Comment successfully deleted.'
        expect(page).to_not have_content 'Comment Body Text'
      end
    end

    scenario "someone else's comment" do
      sign_in(worker)
      visit task_path(comment.task)
      
      within "#comment_#{comment.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Authenticated admin deletes the comment', js: true do
    sign_in(admin)
    visit task_path(task)

    within "#comment_#{comment.id}" do
      expect(page).to have_content 'Comment Body Text'

      click_on 'Delete'
      expect(page).to have_content 'Comment successfully deleted.'
      expect(page).to_not have_content 'Comment Body Text'
    end
  end

  scenario 'Unauthenticated user tryes to delete comment' do
    visit task_path(task)

    within "#comment_#{comment.id}" do
      expect(page).to_not have_link 'Delete'
    end
  end
end
