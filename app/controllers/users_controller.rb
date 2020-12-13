class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :check_admin, except: %i(index show edit update)
  before_action :find_user, except: %i(index new create)
  before_action :check_editor, only: %i(edit update)

  def index; end

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
    redirect_to @user, notice: 'User succesfully updated.' if @user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :login, :fullname,
                                 :birthday, :address, :city, :state, :country, :zip, :role)
  end

  def check_admin
    redirect_to root_path, alert: 'You can not do this' unless current_user.admin?
  end

  def check_editor
    unless current_user.admin? || current_user.id == @user.id
      redirect_to root_path, alert: 'You can not do this'
    end
  end

  def find_user
    @user = User.find(params[:id])
  end
end
