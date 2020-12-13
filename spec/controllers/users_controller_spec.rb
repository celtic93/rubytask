require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user, :client) }

  describe 'GET #index' do
    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: user } }

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'for authenticated admin' do
      before do
        login(admin)
        get :new
      end

      it 'assigns a new user to @user' do
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'for authenticated non-admin' do
      before do
        login(user)
        get :new
      end

      it 'do not assigns a new user to @user' do
        expect(assigns(:user)).to_not be_a_new(User)
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      before { get :new }

      it 'do not assigns a new user to @user' do
        expect(assigns(:user)).to_not be_a_new(User)
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(admin) }

      it 'saves a new user in database' do
        expect { post :create, params: { user: attributes_for(:user) } }.to change(User, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to assigns(:user)
      end
    end

    context 'with invalid attributes' do
      before { login(admin) }

      it 'does not save the user' do
        expect { post :create, format: :js,
                               params: { user: attributes_for(:user, :invalid) } }.to_not change(User, :count)
      end

      it 'renders create view' do
        post :create, params: { user: attributes_for(:user, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'for authenticated non-admin' do
      before { login(user) }

      it 'does not save the user' do
        expect { post :create, format: :js,
                 params: { user: attributes_for(:user) } }.to_not change(User, :count)
      end

      it 'redirects to root page' do
        post :create, params: { user: attributes_for(:user) }

        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      it 'does not save the user' do
        expect { post :create, format: :js,
                 params: { user: attributes_for(:user) } }.to_not change(User, :count)
      end

      it 'redirects to sign in page' do
        post :create, params: { user: attributes_for(:user) }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
