module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  # return current user has been login
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # return true if user login, else return false
  def logged_in?
    current_user.present?
  end

  # log out
  def log_out
    session.delete :user_id
    @current_user = nil
  end
end
