class UsersController < ApplicationController
  before_action :check_login_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :check_correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  helper_method :user

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @microposts = user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Sample Appへようこそ！"
      log_in @user
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit

  end

  def update
    if user.update_attributes(user_params)
      flash[:success] = "更新しました。"
      redirect_to user_path(user)
    else
      render :edit
    end
  end

  def destroy
    if user.destroy
      flash[:success] = "ユーザーを削除しました。"
    else
      flash[:danger] = "ユーザーを削除できませんでした。"
    end
    redirect_to users_path
  end

  def following
    @title = "フォロー"
    @users = user.following.paginate(page: params[:page])
    render :show_follow
  end

  def followers
    @title = "フォロワー"
    @users = user.followers.paginate(page: params[:page])
    render :show_follow
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :unique_name)
    end

    def check_correct_user
      redirect_to root_path unless current_user?(user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    def user
      @user ||= User.find(params[:id])
    end
end
