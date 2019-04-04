class AccountActivationsController < ApplicationController
  before_action :load_user, only: :edit

  def edit
    if !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t "controllers.account.success"
      redirect_to @user
    else
      flash[:danger] = t "controllers.account.danger"
      redirect_to root_path
    end
  end

  private

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user
    flash[:danger] = t "controllers.account.invalid"
    redirect_to root_path
  end
end
