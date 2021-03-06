class UsersController < ApplicationController
  before_action :logged_in_user, only: [:destroy, :index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def create 
    @user = User.new(sanitize_user_params)
    if(@user.save) 
      UserMailer.account_activation(@user).deliver_now
      flash[:success] = "Please check your mail to activate your account"
      redirect_to root_url
    else 
      render 'new'
    end 
  end

  def destroy 
    User.find(params[:id]).delete
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def edit 
    @user = User.find(params[:id])
  end 
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(sanitize_user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
    def sanitize_user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in"
        store_location
        redirect_to login_url
      end
    end
  
    def correct_user 
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
 
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
