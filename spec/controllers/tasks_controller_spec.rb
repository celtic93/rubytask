require 'rails_helper'

RSpec.describe TasksController, type: :controller do  
  let(:task) { create(:task) }
  let(:client) { task.user }
  let(:worker) { create(:user, :worker) }

  describe 'GET #index' do
    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: task } }

    it 'assigns the requested task to @task' do
      expect(assigns(:task)).to eq task
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'for authenticated client' do
      before do
        login(client)
        get :new
      end

      it 'assigns a new task to @task' do
        expect(assigns(:task)).to be_a_new(Task)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'for authenticated worker' do
      before do
        login(worker)
        get :new
      end

      it 'do not assigns a new task to @task' do
        expect(assigns(:task)).to_not be_a_new(Task)
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      before { get :new }

      it 'do not assigns a new task to @task' do
        expect(assigns(:task)).to_not be_a_new(Task)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(client) }

      it 'saves a new task in database' do
        expect { post :create, params: { task: attributes_for(:task) } }.to change(Task, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { task: attributes_for(:task) }
        expect(response).to redirect_to assigns(:task)
      end
    end

    context 'with invalid attributes' do
      before { login(client) }

      it 'does not save the task' do
        expect { post :create, format: :js,
                               params: { task: attributes_for(:task, :invalid) } }.to_not change(Task, :count)
      end

      it 'renders create view' do
        post :create, params: { task: attributes_for(:task, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'for authenticated worker' do
      before { login(worker) }

      it 'does not save the task' do
        expect { post :create, format: :js,
                 params: { task: attributes_for(:task) } }.to_not change(Task, :count)
      end

      it 'redirects to root page' do
        post :create, params: { task: attributes_for(:task) }

        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      it 'does not save the task' do
        expect { post :create, format: :js,
                 params: { task: attributes_for(:task) } }.to_not change(Task, :count)
      end

      it 'redirects to sign in page' do
        post :create, params: { task: attributes_for(:task) }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end  
end
