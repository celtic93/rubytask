require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:task) { create(:task) }
  let(:client) { task.user }
  let(:worker) { create(:user, :worker) }
  let(:admin) { create(:user, :admin) }

  describe 'POST #create' do
    context 'for client' do
      context 'with valid attributes' do
        before { login(client) }

        it 'saves a new comment in database' do
          expect { post :create, params: { comment: attributes_for(:comment),
                                           task_id: task }, format: :js }.to change(task.comments, :count).by(1)
        end

        it 'renders create view' do
          post :create, params: { comment: attributes_for(:comment),
                                  task_id: task }, format: :js

          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        before { login(client) }

        it 'does not save the comment in database' do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid),
                                           task_id: task }, format: :js }.to_not change(task.comments, :count)
        end

        it 'renders create view' do
          post :create, params: { comment: attributes_for(:comment, :invalid),
                                  task_id: task }, format: :js

          expect(response).to render_template :create
        end
      end
    end

    context 'for worker' do
      context 'with valid attributes' do
        before { login(worker) }

        it 'saves a new comment in database' do
          expect { post :create, params: { comment: attributes_for(:comment),
                                           task_id: task }, format: :js }.to change(task.comments, :count).by(1)
        end

        it 'renders create view' do
          post :create, params: { comment: attributes_for(:comment),
                                  task_id: task }, format: :js

          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        before { login(worker) }

        it 'does not save the comment in database' do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid),
                                           task_id: task }, format: :js }.to_not change(task.comments, :count)
        end

        it 'renders create view' do
          post :create, params: { comment: attributes_for(:comment, :invalid),
                                  task_id: task }, format: :js

          expect(response).to render_template :create
        end
      end
    end

    context 'for unauthenticated user' do
      before { login(admin) }

      it 'does not save the comment in database' do
        expect { post :create, params: { comment: attributes_for(:comment, :invalid),
                                         task_id: task } }.to_not change(task.comments, :count)
      end

      it 'redirects to root page' do
        post :create, params: { comment: attributes_for(:comment, :invalid), task_id: task }

        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      it 'does not save the comment in database' do
        expect { post :create, params: { comment: attributes_for(:comment, :invalid),
                                         task_id: task } }.to_not change(task.comments, :count)
      end

      it 'redirects to sign up page' do
        post :create, params: { comment: attributes_for(:comment, :invalid), task_id: task }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
