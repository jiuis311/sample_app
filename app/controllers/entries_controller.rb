class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: [:destroy]

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new entry_params
    @entry.user_id = params[:user_id]
    if @entry.save
      flash[:success] = "New entry created"
      redirect_to @entry
    else
      render :new
    end
  end

  def show
    @entry = Entry.find_by id: params[:id]
    @comments = @entry.comments.take(5)
  end

  def edit
    @entry = Entry.find_by id: params[:id]
  end

  def update
    @entry = Entry.find_by id: params[:id]
    if @entry.update_attributes entry_params
      flash[:success] = "Updated"
      redirect_to @entry
    else
      render :edit
    end
  end

  def destroy
    @entry = Entry.find_by id: params[:id]
    @entry.destroy
    flash[:success] = t("deleted")
    redirect_to root_path
  end

  private
  def entry_params
    params.require(:entry).permit :subject, :content, :picture
  end

  def correct_user
    @entry = Entry.find_by id: params[:id]
    redirect_to root_path unless @entry&.user.current_user? current_user
  end
end
