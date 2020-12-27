class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    target_post = Micropost.find(params[:micropost_id]) #Microsoftテーブルからidに対応するポストをtarget_postへ代入
    current_user.add2favorite(target_post)
    #binding.pry
    flash[:success] = '投稿をお気に入りに登録しました'
    redirect_to root_path
  end

  def destroy
    target_post = Micropost.find(params[:micropost_id])
    current_user.rm_favorite(target_post)
    #binding.pry
    flash[:success] = 'お気に入りから削除しました'
    redirect_to root_path
  end
end
