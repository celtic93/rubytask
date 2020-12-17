require 'rails_helper'

feature 'User can browse all tasks' do
  let!(:task1) { create(:task, body: %q{Also, if you have a sentence 
                                        that you love from a particular author, 
                                        and you think it’s a better sentence than 
                                        the one I’ve quoted, please, by all means, 
                                        let’s have the sentences do battle! Post 
                                        it and we’ll see whether it’s better.}) }
  let!(:task2) { create(:task, body: %q{As far as improving the list, I’d love to 
                                        make it more diverse. If you have suggestions 
                                        of 100+ word sentences from the type of authors 
                                        who aren’t represented here, I would love if 
                                        you could post your example in the comments, 
                                        or at least direct me to where I could find it.}) }

  scenario 'User visit page with all tasks' do
    visit tasks_path

    expect(page).to have_content(%w{Also, if you have a sentence that you 
                                  love from a particular author, and...}.join(' '))
    expect(page).to_not have_content(%w{you think it’s a better sentence than 
                                        the one I’ve quoted, please, by all means, 
                                        let’s have the sentences do battle! Post 
                                        it and we’ll see whether it’s better.}.join(' '))
    expect(page).to have_content(%w{As far as improving the list, I’d love 
                                    to make it more diverse. If you have suggestions ...}.join(' '))
    expect(page).to_not have_content(%w{of 100+ word sentences from the type of authors 
                                        who aren’t represented here, I would love if 
                                        you could post your example in the comments, 
                                        or at least direct me to where I could find it.}.join(' '))

    expect(page).to have_content task1.user.fullname
    expect(page).to have_content task2.user.fullname
  end
end
