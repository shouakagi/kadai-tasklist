class MicropostsController < ApplicationController
  before_action :require_user_logged_in

  def create
    @tasklist = current_user.microposts.build(tasklist_params)
    if @tasklist.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @tasklists = current_user.microposts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @tasklist.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  private

  def tasklist_params
    params.require(:tasklist).permit(:content)
  end
  
  def correct_user
    @tasklist = current_user.tasklists.find_by(id: params[:id])
    unless @tasklist
      redirect_to root_url
    end
  end
  
end
