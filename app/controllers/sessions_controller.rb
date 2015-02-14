class SessionsController < ApplicationController
  def new
  end
  def delete
    log_out if logged_in?
    redirect_to root_path
  end 
  
  def create 
    user = User.find_by(:email => params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) 
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = "account not activated. check your mail"
        redirect_to root_url
      end
    else 
      flash.now[:danger] = "Incorrect password/email"
      render 'new'
    end
  end
end
