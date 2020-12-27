class ApplicationController < ActionController::Base
    
    include SessionsHelper
    
    private
    
    def require_user_logged_in
        unless logged_in?
            redirect_to login_url
        end
    end

  def counts(user)
    @count_microposts = user.microposts.count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
    @count_likes = user.likes.count#お気に入り投稿数をカウント
    #@count_famousfor = user.famousfor.count#お気に入りに登録されている数をカウント
  end
end
