class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = case params[:username]
            when EMAIL_FORMAT then
              User.find_by_email params[:username]
            when /[\w]+/ then
              User.find_by_username params[:username]
            else
              nil
            end
    if @user
      if @user.password_matches? params[:password]
        session[:user_id] = @user.id
        redirect_to my_profile_url unless @user.admin?
        redirect_to admin_url if @user.admin?
      else
        flash[:error] = "Your password was incorrect"
        render :action => :new
      end
    else
      flash[:error] = "Your login details were incorrect"
      render :action => :new
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
