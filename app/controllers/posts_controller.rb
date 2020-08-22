class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])

    @comment = Comment.new     # フォーム用のインスタンス作成(コメント追加用)
    @comments = @post.comments # コメント一覧表示用
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    if @post.save
      # 成功の場合
      redirect_to root_path, notice: '登録しました'
    else
      # 失敗の場合
      flash.now[:alert] = '登録に失敗しました'
      render :new
    end
  end

  def edit
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      redirect_to post_path(post), notice: '更新しました'
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      redirect_to root_path, notice: '削除しました'
    else
      flash.now[:alert] = '削除に失敗しました'
      render :edit
    end
  end

  private
  def post_params
    params.require(:post).permit(
      :problem, 
      :existing, 
      :solution, 
      :metics, 
      :value,
      :advantage, 
      :channel, 
      :customer, 
      :cost, 
      :revenue).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.includes(:user).find(params[:id])
  end

  def correct_user
    @post = Post.find(params[:id])
    if @post.user_id != current_user.id
      redirect_to post_path(@post), flash: {key: "投稿したユーザーのみ可能です"}
    end
  end
end
