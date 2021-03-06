class TasksController < ApplicationController
    before_action :require_user_logged_in
    before_action :correct_user, only: [:destroy, :edit, :update, :show]
    
    def index
          @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
    end

    def show
    end

    def new
        @task = Task.new
    end

    def create
        @task = current_user.tasks.build (task_params)
        if @task.save
            flash[:success] = "タスクリストに追加されました"
            redirect_to root_url
        else
            @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
            flash.now[:danger] = 'タスクリストに追加できませんでした'
            render :new
        end
    end

    def edit
        
    end

    def update
      

      if @task.update(task_params)
        flash[:success] = 'タスクは更新されました'
        redirect_to @task
      else
        flash.now[:danger] = 'タスクは更新されませんでした'
        render :edit
      end
    end

    def destroy
        @task.destroy
        
        flash[:success] = 'タスクは正常に削除されました'
        redirect_back(fallback_location: root_path)
    end
    
     private

     # Strong Parameter
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
