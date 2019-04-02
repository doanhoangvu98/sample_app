class SessionsController < ApplicationController
  before_action :load_user, only: :create
  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      # login and redirect to user page
      log_in @user
      params[:session][:remember_me] ==
        Settings.create.remember ?
        remember(@user) : forget(@user)
      # remember user
      redirect_to @user
      #redirect_back_or @user
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
