class FavoritesController < ApplicationController
  before_action :set_post

  def create
    @favorite = Favorite.create(user_id: current_user.id, post_id: @post.id)
  end

  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, post_id: @post.id)
    @favorite.destroy
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end
end
