class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create 
    @user = User.new(sanitize_user_params)
    if(@user.save) 
      flash[:success] = "Welcome to App"
      redirect_to @user
    else 
      render 'new'
    end 
  end 
  
  private
    def sanitize_user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
