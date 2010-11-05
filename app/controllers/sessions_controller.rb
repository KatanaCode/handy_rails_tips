class SessionsController < ApplicationController
    
  def new
  end
  
  def create
    @user = User.find_from_params params

    if @user
      session[:user_id] = @user.id
      redirect_to tips_url, :notice => "Successfully logged in!"
    else
      flash[:error] = "Your login details were incorrect"
      render :new
    end
  end
  
  
  def destroy
    session[:user_id] = @current_user = nil
    redirect_to root_url, :notice => "Successfully logged out!"    
  end
end
