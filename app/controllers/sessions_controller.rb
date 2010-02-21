class SessionsController < ApplicationController
    
  def new
  end
  
  def create
    @user = User.find_from_params params

    if @user
      session[:user_id] = @user.id
      redirect_to my_profile_url
    else
      flash[:error] = "Your login details were incorrect"
      render "new"
    end
  end
  
  def login_with_token
    @user = User.find params[:id]
    if @user.token == params[:token]
      session[:user_id] = @user.id
      @user.reset_token
      redirect_to reset_password_path
    else
      flash[:error] = "The link you followed was not valid"
      redirect_to notice_path
    end
  end
  
  def destroy
    session[:user_id] = @current_user = nil
  end
end
