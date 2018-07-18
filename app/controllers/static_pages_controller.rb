class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.order(updated_at: :desc).paginate(page: params[:page])
    else
      @feed_items = Entry.order(updated_at: :desc).paginate(page: params[:page])
    end
  end

  def help; end

  def about; end

  def contact; end
end
