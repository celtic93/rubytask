class TaskRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_worker, only: %i(create my_works)
  before_action :find_task, only: :create
  before_action :find_task_request, only: %i(accept reject)
  before_action :check_author, only: %i(accept reject)

  def create
    @task_request = TaskRequest.create(user: @task.user,
                                       task: @task,
                                       worker: current_user)
  end

  def my_works
    @work_requests = current_user.work_requests.includes(:task)
  end

  def accept
    TaskRequest.transaction do
      @task_request.accepted!
      @task.update(worker: @worker)
    end
  end

  def reject
    @task_request.rejected!
  end

  private

  def check_worker
    redirect_to root_path, alert: 'You can not do this' unless current_user.worker?
  end

  def find_task
    @task = Task.includes(:user).find(params[:id])
  end

  def find_task_request
    @task_request = TaskRequest.includes(:worker, :task).find_by(task_id: params[:task_id],
                                                                 user: current_user,
                                                                 worker_id: params[:worker_id])

    @worker = @task_request.worker
    @task = @task_request.task
  end

  def check_author
    unless current_user.author?(@task) && current_user.client?
      redirect_to root_path, alert: 'You can not do this'
    end
  end
end
