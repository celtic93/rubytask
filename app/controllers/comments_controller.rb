class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_role, only: :create
  before_action :find_task, only: :create
  before_action :find_comment, only: %i(update destroy)
  before_action :check_author, only: :update
  before_action :check_destroyer, only: :destroy

  def create
    @comment = @task.comments.create(comment_params.merge(user: current_user))
  end

  def update
    @comment.update(comment_params)
  end

  def destroy
    @comment.destroy
  end

  private

  def check_role
    redirect_to root_path, alert: 'You can not do this' if current_user.admin?
  end

  def find_task
    @task = Task.find(params[:task_id])
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def check_author
    redirect_to root_path, alert: 'You can not do this' unless current_user.author?(@comment)
  end

  def check_destroyer
    unless current_user.author?(@comment) || current_user.admin?
      redirect_to root_path, alert: 'You can not do this'
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
