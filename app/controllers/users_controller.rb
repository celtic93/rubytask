class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :check_admin, except: %i(index show edit update)
  before_action :find_user, except: %i(index new create)
  before_action :check_editor, only: %i(edit update)

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    redirect_to @user, notice: 'User succesfully created.' if @user.save
  end

  def edit; end

  def update
    if @user.update(user_params)
      bypass_sign_in(@user) if @current_user_profile
      redirect_to @user, notice: 'User succesfully updated.'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User succesfully deleted.'
  end

  private

  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    params.require(:user).permit(:email, :password, :password_confirmation, :login, :fullname,
                                 :birthday, :address, :city, :state, :country, :zip, :role)
  end

  def check_admin
    redirect_to root_path, alert: 'You can not do this' unless current_user.admin?
  end

  def check_editor
    @current_user_profile = current_user.id == @user.id

    unless current_user.admin? || @current_user_profile
      redirect_to root_path, alert: 'You can not do this'
    end
  end

  def find_user
    @user = User.find(params[:id])
  end
end
