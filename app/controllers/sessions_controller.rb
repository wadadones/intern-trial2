class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember?(params[:session][:remember_me]) ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'メールまたはパスワードが不正です。'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
    def remember?(session)
      ActiveRecord::Type::Boolean.new.cast(session)
    end
end
