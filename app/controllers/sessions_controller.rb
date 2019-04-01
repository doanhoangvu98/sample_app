class SessionsController < ApplicationController
  before_action :load_user, only: :create
  def new; end

  def create
    if @user.authenticate(params[:session][:password])
      # login and redirect to user page
      log_in @user
      if params[:session][:remember_me] == Settings.create.remember
        remember @user
      else
        forget @user
      end
      # remember user
      redirect_to @user
    else
      flash.now[:danger] = t "controllers.sessions.invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user
    flash[:danger] = t "controllers.sessions.invalid"
    redirect_to root_path
  end
end
