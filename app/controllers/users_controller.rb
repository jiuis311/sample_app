class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: [:show, :edit, :update,
                                   :destroy, :correct_user]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.select_user_activated.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      log_in @user
      flash[:success] = t("welcome")
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @microposts = @user.microposts.order(updated_at: :desc)
                       .page(params[:page])
                       .per_page Settings.user.paginate.per_page
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t("profile_updated")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t("deleted")
    redirect_to users_url
  end

  def following
    @title = t("following")
    @user  = User.find_by id: params[:id]
    @users = @user.following.order(updated_at: :desc).paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = t("followers")
    @user  = User.find_by id: params[:id]
    @users = @user.followers.order(updated_at: :desc).paginate(page: params[:page])
    render "show_follow"
  end

  private
  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end

  def correct_user
    redirect_to root_path unless @user&.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]

    return @user if @user
    flash[:warning] = t("no_user_warning")
    redirect_to root_path
  end
end
