class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_role, only: :create
  before_action :find_task, only: :create

  def create
    @comment = @task.comments.create(comment_params.merge(user: current_user))
  end

  private

  def check_role
    redirect_to root_path, alert: 'You can not do this' if current_user.admin?
  end

  def find_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
