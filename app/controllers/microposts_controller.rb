class MicropostsController < ApplicationController
  before_action :check_login_user, only: [:create, :destroy]
  before_action :check_correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    get_reply_info
    if @micropost.save
      flash[:success] = "投稿が完了しました。"
      redirect_to root_path
    else
      flash[:danger] = "投稿内容を記入してください。"
      redirect_to root_path
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = "投稿を削除しました。"
    else
      flash[:danger] = "投稿を削除できませんでした"
    end
    redirect_to request.referrer || root_path
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def check_correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_path unless @micropost.present?
    end

    def get_reply_info
      re = /@([0-9a-z_]{5,15})/i
      @micropost.content.match(re)
      if $1
        reply_user = User.find_by(unique_name: $1.downcase)
        @micropost.in_reply_to = reply_user.id if reply_user
      end
    end
end
