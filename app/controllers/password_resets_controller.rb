class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new
    
  end
  
  def create 
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_mail
      flash[:success] = "email sent for password reset"
      redirect_to root_url
    else
      flash[:danger] = "email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if password_blank?
      flash[:danger] = "Blank password"
      render 'new' 
    elsif(@user.update_attributes(user_params))
      log_in @user
      flash[:success] = "Password updated successfully"
      redirect_to @user
    else 
      render 'new'
    end
  end

  private 
  
  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user 
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)    
  end
 
  def password_blank?
    params[:user][:password].blank?
  end

  def check_expiration
    if(@user.password_reset_expired?)
      flash[:danger] = "Reset expired"
      redirect_to new_password_reset_url
    end
  end 
end
