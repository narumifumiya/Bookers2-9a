class RelationshipsController < ApplicationController
  
  # フォローするとき follow(user_id)はuser.rbに記述したメソッドを使用している
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  # フォロー外すとき　unfollow(user_id)はuser.rbに記述したメソッドを使用している
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer  
  end
  # フォロー一覧ページ
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end
  # フォロワー一覧ページ
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
  
end
