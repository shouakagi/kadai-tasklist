class TasksController < ApplicationController

    before_action :set_task, only: [:show, :edit,:update, :destroy]
    before_action :correct_user, only: [:show, :edit,:update, :destroy]
    before_action :require_user_logged_in

    def index
      @tasks = Task.all
    end

    def show
       set_task
    end
  
  
    def new
        @task =Task.new
    end
  

  
    def create
        @task = current_user.tasks.build(task_params)
        if @task.save
            flash[:success] = 'タスクが投稿されました'
             redirect_to @task
        else
             @tasks = current_user.tasks.order(id: :desc).page(params[:page])
            flash[:danger] = 'タスクが投稿されません'
             render :new
        end
    end
    

      def edit
      end

    def update
        set_task
        if @task.update(task_params)
           flash[:success] = 'タスクが編集されました'
            redirect_to @task
        else
           flash.now[:danger] = 'タスクが編集されませんでした'
            render :new
        end
    end
    
    def destroy
        @task.destroy
        flash[:success] = 'メッセージを削除しました。'
        redirect_to tasks_url
    end

    private

    def task_params
        params.require(:task).permit(:content, :status)
    end

    def set_task
        @task = current_user.tasks.find_by(id: params[:id])
    end
    
    def correct_user
        @task = current_user.tasks.find_by(id: params[:id])
        unless @task
            redirect_to root_url
        end
    end
end
    