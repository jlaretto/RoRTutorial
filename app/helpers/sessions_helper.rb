module SessionsHelper

  def sign_in (user)
    cookies.permanent[:remember_token] = user.remember_token
    current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  
  def current_user?(user)
    current_user ==  user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def destroy_session
    cookies[:remember_token] = nil
    current_user = nil
  end
  
  def store_redirect 
    session[:redirectPath] = request.fullpath
  end
  
  def clear_redirect
    session.delete :redirectPath
  end
  
  def redirect_helper (default)
    redirect_to (session[:redirectPath] || default)
    clear_redirect
  end
  
  def signed_in_user
    unless signed_in?
      store_redirect
      redirect_to signin_path, :notice => "Please sign in" 
    end
  end
end
