class SessionsController < ApplicationController
  def new
  
  end

  def create
      user = User.find_by_email(params[:session][:email])
      if user && user.authenticate(params[:session][:password])
          sign_in user
          redirect_helper (user)
      else
          flash.now[:error] = "Invalid email/password combination"
          render 'new'
      end
  end
  
    
  def destroy
    destroy_session
    redirect_to signin_path
  end
end
