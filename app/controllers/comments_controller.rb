class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.new (comment_params)

    if @comment.save
      redirect_to post_path(@post), notice: 'コメントしました'
    else
      # flash.now[:alert] = 'コメントに失敗しました'
      redirect_to post_path(@post), notice: 'コメントに失敗しました'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      redirect_to post_path(@post), notice: 'コメントを削除しました'
    else
      flash.now[:alert] = 'コメントを削除できませんでした'
      render post_path(@post)
    end
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.required(:comment).permit(:comment).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
