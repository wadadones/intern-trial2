class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
    #ユーザーのログインを確認
    def check_login_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_path
      end
    end
end
