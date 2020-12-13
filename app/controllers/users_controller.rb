class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :check_admin, except: %i(index show)
  before_action :find_user, except: %i(index new create)

  def index; end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    redirect_to @user, notice: 'User succesfully created.' if @user.save
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :login, :fullname,
                                 :birthday, :address, :city, :state, :country, :zip, :role)
  end

  def check_admin
    redirect_to root_path, alert: 'You can not do this' unless current_user.admin?
  end

  def find_user
    @user = User.find(params[:id])
  end
end
