class TasksController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :check_client, except: %i(index show)
  before_action :find_task, except: %i(index new create)
  before_action :check_author, only: %i(edit)

  def index; end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    
    redirect_to @task, notice: 'Your task succesfully created.' if @task.save
  end

  def edit; end

  def update
    redirect_to @task, notice: 'Your task succesfully updated.' if @task.update(task_params)
  end

  private

  def task_params
    params.require(:task).permit(:body)
  end

  def check_client
    redirect_to root_path, alert: 'You can not do this' unless current_user&.client?
  end

  def check_author
    redirect_to root_path, alert: 'You can not do this' unless current_user.author?(@task)
  end

  def find_task
    @task = Task.includes(:user).find(params[:id])
  end
end
