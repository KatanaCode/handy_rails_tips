class ForgotPasswordController < ApplicationController
  def index
  end
  
  def send_email
    @user = User.find_by_email params[:email]
    redirect_to notice_path
    if @user
      flash[:notice] = "An email has been sent to #{@user.email}"
      Notifier.deliver_forgot_password(@user)
    else
      flash[:error] = "The email you gave was not recognised"
    end
  end


end
