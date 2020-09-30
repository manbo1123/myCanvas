class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
    @tags = Post.tag_counts_on(:tags).most_used(20)    # タグ一覧表示
    if @tag = params[:tag]   # タグ検索
      @post = Post.tagged_with(params[:tag])
    end
  end

  def show
    @comment = Comment.new     # フォーム用のインスタンス作成(コメント追加用)
    @comments = @post.comments # コメント一覧表示用

    @tags = @post.tag_counts_on(:tags)
  end

  def new
    @post = Post.new
    @post.imgs.build 
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      # 成功の場合
      redirect_to post_path(@post), notice: '登録しました'
    else
      # 失敗の場合
      flash.now[:alert] = '登録に失敗しました'
      render :new
    end
  end

  def edit
  end

  def get_tag_search  # タグ入力時のインクリメンタルサーチ
    @tags = Post.tag_counts_on(:tags).where('name LIKE(?)', "%#{params[:key]}%")
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '更新しました'
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit
    end
  end

  def destroy
    if @post.destroy
      redirect_to root_path, notice: '削除しました'
    else
      flash.now[:alert] = '削除に失敗しました'
      render :edit
    end
  end

  private
  def post_params
    params.require(:post).permit(
      :purpose,
      :vision,
      :problem, 
      :existing, 
      :solution, 
      :metics, 
      :value,
      :advantage, 
      :channel, 
      :customer, 
      :cost, 
      :revenue,
      :note,
      :tag_list,
      imgs_attributes: [:src, :_destroy, :id]
      ).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def correct_user
    @post = Post.find(params[:id])
    if @post.user_id != current_user.id
      redirect_to post_path(@post), flash: {key: "投稿したユーザーのみ可能です"}
    end
  end
end
