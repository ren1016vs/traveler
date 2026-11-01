class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @users = User.page(params[:page]).per(5).reverse_order
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(8).reverse_order
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def follows
    @user = User.find(params[:id])
    @users = @user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.follower_user.page(params[:page]).per(3).reverse_order
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user) unless @user == current_user
  end
end