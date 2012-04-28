class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user, :only =>[:edit, :update]
  before_filter :admin_user, only: [:destroy]
  def new
    @user = @obj = User.new
    
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in(@user)
      flash[:success] = "Welcome to the site!"
      redirect_to (@user)
    else
      @obj = @user
      render 'new'
    end
  end
  
  def edit
      @user = @obj = User.find(params[:id])
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def update
    @user = @obj = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile Updated!"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
    
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

private
  


  def correct_user
    unless current_user.id ==  params[:id].to_i
      redirect_to root_path 
    end
  end

  def admin_user
    redirect_to users_path unless current_user.admin?
  end
end
