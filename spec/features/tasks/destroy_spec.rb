require 'rails_helper'

feature 'User can delete task' do
  given (:task) { create(:task) }
  given (:client) { task.user }
  given (:worker) { create(:user, :worker) }

  describe 'Authenticated user tryes to delete task' do
    scenario 'his task' do
      sign_in(client)
      visit task_path(task)

      click_on 'Delete Task'
      expect(page).to have_content 'Your task succesfully deleted.'
    end

    scenario "someone else's task" do
      sign_in(worker)
      visit task_path(task)

      expect(page).to_not have_link 'Delete Task'
    end
  end

  scenario 'Unauthenticated user tryes to delete task' do
    visit task_path(task)

    expect(page).to_not have_link 'Delete Task'
  end
end
