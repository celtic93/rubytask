require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user, :client) }
  let(:user_email) { user.email }

  describe 'GET #index' do
    before { get :index }

    it 'assigns all users to @users' do
      expect(assigns(:users)).to eq [admin, user]
    end

    it 'renders index view' do
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

  describe 'GET #edit' do
    context 'for authenticated admin' do
      before do
        login(admin)
        get :edit, params: { id: user }
      end

      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'for authenticated user with his profile' do
      before do
        login(user)
        get :edit, params: { id: user }
      end

      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'for authenticated user with other user profile' do
      before do
        login(user)
        get :edit, params: { id: admin }
      end

      it 'do not assigns the requested user to @user' do
        expect(assigns(:user)).to_not eq user
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      before { get :edit, params: { id: user } }

      it 'do not assigns the requested user to @user' do
        expect(assigns(:user)).to_not eq user
      end

      it 'redirects to sign up page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'for admin' do
      context 'with valid attributes' do
        before { login(admin) }

        it 'assigns the requested user to @user' do
          patch :update, params: { id: user, user: attributes_for(:user) }
          expect(assigns(:user)).to eq user
        end

        it 'changes user attributes' do
          patch :update, params: { id: user, user: {  email: 'aa@aaa.aa' } }
          user.reload

          expect(user.email).to eq 'aa@aaa.aa'
        end

        it 'redirects to show view' do
          patch :update, params: { id: user, user: attributes_for(:user) }
          expect(response).to redirect_to user
        end
      end

      context 'with invalid attributes' do
        before do
          login(admin)
          patch :update, params: { id: user, user: attributes_for(:user, :invalid) }, format: :js
        end

        it 'does not change user' do
          user.reload

          expect(user.email).to eq user_email
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'for user and his profile' do
      context 'with valid attributes' do
        before { login(user) }

        it 'assigns the requested user to @user' do
          patch :update, params: { id: user, user: attributes_for(:user) }
          expect(assigns(:user)).to eq user
        end

        it 'changes user attributes' do
          patch :update, params: { id: user, user: { email: 'aa@aaa.aa' } }
          user.reload

          expect(user.email).to eq 'aa@aaa.aa'
        end

        it 'redirects to show view' do
          patch :update, params: { id: user, user: attributes_for(:user) }
          expect(response).to redirect_to user
        end
      end

      context 'with invalid attributes' do
        before do
          login(user)
          patch :update, params: { id: user, user: attributes_for(:user, :invalid) }, format: :js
        end

        it 'does not change user' do
          user.reload

          expect(user.email).to eq user_email
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'for user and other profile' do
      before do
        login(user)
        patch :update, params: { id: admin, user: { email: 'aa@aaa.aa' } }
      end

      it 'does not change user' do
        user.reload

        expect(user.email).to eq user_email
      end

      it 'redirects to main page' do
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      before { patch :update, params: { id: user, user: { email: 'aa@aaa.aa' } } }

      it 'does not change user' do
        user.reload

        expect(user.email).to eq user_email
      end

      it 'redirects to sign up page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'for the admin' do
      before { login(admin) }

      it 'deletes the user' do
        expect { delete :destroy, params: { id: user } }.to change(User, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: user }
        expect(response).to redirect_to users_path
      end
    end

    context 'for not the admin' do
      before { login(user) }

      it "don't delete the user" do
        expect { delete :destroy, params: { id: admin } }.to_not change(User, :count)
      end

      it 'redirects to main page' do
        delete :destroy, params: { id: admin }
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      it "don't delete the user" do
        expect { delete :destroy, params: { id: user } }.to_not change(User, :count)
      end

      it 'redirects to sign up page' do
        delete :destroy, params: { id: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
