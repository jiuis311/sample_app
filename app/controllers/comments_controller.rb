class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update, :destroy]
  before_action :correct_user, only: [:update, :destroy]
  def create
    @comment = Comment.new
    @comment.content = params["content"]
    @comment.user_id = current_user.id
    @comment.entry_id = params["entry_id"]
    if @comment.save
      flash[:success] = "New comment created"
    end
    redirect_to @comment.entry
  end

  def edit
    @comment = Comment.find_by id: params[:id]
    respond_to do |format|
      format.html {redirect_to @comment.entry}
      format.js
    end
  end

  def update
    @comment = Comment.find_by id: params[:id]
    @comment.content = params[:content]
    @comment.save
    respond_to do |format|
      format.html {redirect_to @comment.entry}
      format.js
    end
  end

  def destroy
    @comment = Comment.find_by id: params[:id]
    @comment.destroy
    flash[:success] = t("deleted")
    respond_to do |format|
      format.html {redirect_to @comment.entry}
      format.js
    end
  end

  private
  def comment_params
    params.require(:comment).permit :content
  end

  def correct_user
    @comment = Comment.find_by id: params[:id]
    redirect_to root_path unless @comment&.user.current_user? current_user
  end
end
