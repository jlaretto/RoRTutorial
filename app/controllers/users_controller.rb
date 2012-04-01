class UsersController < ApplicationController
  def new
    @user = @obj = User.new
    
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the site!"
      redirect_to @user
    else
      @obj = @user
      render 'new'
    end
  end
    
  def show
    @user = User.find(params[:id])
  end
end
