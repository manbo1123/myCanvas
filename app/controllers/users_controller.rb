class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = @user.posts

    favorites = Favorite.where(user_id: current_user.id).pluck(:post_id)  # ログイン中のユーザーのお気に入りのpost_idカラムを取得
    @favorite_list = Post.find(favorites)     # postsテーブルから、お気に入り登録済みのレコードを取得
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path, notice: 'ユーザー情報を更新しました'
    else
      flash.now[:alert] = 'ユーザー情報の更新に失敗しました'
      render :edit
    end
  end

  private
  def user_params
    params.requre(:user).permit(:name, :email)
  end
end
