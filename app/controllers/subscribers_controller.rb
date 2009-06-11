class SubscribersController < ApplicationController
  before_filter :admin_login_required, :only => [:index, :destroy]
  
  def index
    @subscribers = Subscriber.all :order => "email ASC"
  end
  
  def new
    
  end
  
  def create
    @subscriber.email = params[:subscriber][:email]
    if @subscriber.save
      flash[:notice] = "Thanks for subscribing! You should receive the first email shortly"
      redirect_to notice_url
    else
      render :action => "new"      
    end
  end

  def destroy
    @subscriber = Subscriber.find params[:id]
    @subscriber.destroy
    redirect_to subscribers_url
    flash[:notice] = "Email address removed from mailing list"
  end
end
