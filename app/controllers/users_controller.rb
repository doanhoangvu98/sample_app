class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def show
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.page
  end

  def new
    @user = User.new
  end

  def index
    @users = User.paginate page: params[:page], per_page: Settings.page
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controllers.users.checkmail"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "controllers.users.update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.users.delete"
      redirect_to users_path
    else
      flash[:danger] = t "controllers.users.danger"
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confrimation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controllers.sessions.invalid"
    redirect_to root_path
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controllers.users.login"
    redirect_to login_path
  end

  # confirms the correct user
  def correct_user
    redirect_to root_path unless current_user? @user
  end

  # confirms an admin user.
  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
