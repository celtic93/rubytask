require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:task) { create(:task) }
  let(:client) { task.user }
  let(:worker) { create(:user, :worker) }
  let(:admin) { create(:user, :admin) }
  let!(:comment) { create(:comment, user: client, task: task) }

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

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { login(client) }

      it 'assigns the requested comment to @comment' do
        patch :update, params: { id: comment, task_id: task, comment: attributes_for(:comment) }, format: :js
        expect(assigns(:comment)).to eq comment
      end

      it 'changes comment attributes' do
        patch :update, params: { id: comment, task_id: task, comment: { body: 'new comment body' } }, format: :js
        comment.reload

        expect(comment.body).to eq 'new comment body'
      end

      it 'renders update' do
        patch :update, params: { id: comment, task_id: task, comment: attributes_for(:comment) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        login(client)
        patch :update, params: { id: comment, task_id: task, comment: attributes_for(:comment, :invalid) }, format: :js
      end

      it 'does not change comment' do
        comment.reload

        expect(comment.body).to eq 'Comment Body Text'
      end

      it 'renders update' do
        expect(response).to render_template :update
      end
    end

    context 'for not the author of the comment' do
      before do
        login(worker)
        patch :update, params: { id: comment, task_id: task, comment: { body: 'body' } }
      end

      it 'does not change comment' do
        comment.reload

        expect(comment.body).to eq 'Comment Body Text'
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end  
    end

    context 'for unauthenticated user' do
      before { patch :update, params: { id: comment, task_id: task, comment: { body: 'body' } } }

      it 'does not change comment' do
        comment.reload

        expect(comment.body).to eq 'Comment Body Text'
      end

      it 'redirects to sign up page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'for the author of the comment' do
      before { login(client) }

      it 'deletes the comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to change(task.comments, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: comment, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'for the admin' do
      before { login(admin) }

      it 'deletes the comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to change(task.comments, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: comment, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'for not the author of the comment' do
      before { login(worker) }

      it "don't delete the comment" do
        expect { delete :destroy, params: { id: comment } }.to_not change(task.comments, :count)
      end

      it 'redirects to root path' do
        delete :destroy, params: { id: comment }
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      it "don't delete the comment" do
        expect { delete :destroy, params: { id: comment } }.to_not change(task.comments, :count)
      end

      it 'redirects to sign up page' do
        delete :destroy, params: { id: comment }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
