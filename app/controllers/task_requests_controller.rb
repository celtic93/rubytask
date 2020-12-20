class TaskRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_worker, only: :create
  before_action :find_task, only: :create

  def create
    @task_request = TaskRequest.create(user: @task.user,
                                       task: @task,
                                       worker: current_user)
  end

  private

  def check_worker
    redirect_to root_path, alert: 'You can not do this' unless current_user.worker?
  end

  def find_task
    @task = Task.includes(:user).find(params[:id])
  end
end
