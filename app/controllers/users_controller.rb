class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :myfavorites]

  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def followings#数をカウントするだけ
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers#数をカウントするだけ
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def myfavorites #数をカウントするだけ
    #@microposts = Micropost.find(params[:micropost_id])
    @user = User.find(params[:id])
    #binding.pry
    @myfavorites = @user.myfavorites.page(params[:page])
    counts(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end