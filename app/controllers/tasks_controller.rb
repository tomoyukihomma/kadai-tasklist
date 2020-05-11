class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit]
  
  def index
    @task = current_user.tasks.build
    @tasks = current_user.tasks.order(id: :desc)
  end

  def show
    @task = current_user.find(params[:id])
  end
  
  def new
    @task =current_user.tasks.new
  end
    
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクを投稿しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc)
      flash.now[:danger] = 'タスクの投稿に失敗しました。'
      render :new
    end
  end
  
  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def destroy
    @task.destroy
    flash[:success] = 'タスクを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  private

  def task_params
    params.require(:task).permit(:content, :status)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end