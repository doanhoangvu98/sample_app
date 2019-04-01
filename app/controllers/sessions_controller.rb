class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      # login and redirect to user page
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t "controllers.sessions.invalid"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
