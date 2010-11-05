class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => :destroy
    
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
    redirect_to root_url, :notice => "Successfully logged out!"    
    session[:user_id] = @current_user = nil    
  end
end
