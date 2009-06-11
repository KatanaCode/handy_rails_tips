class FeedbacksController < ApplicationController
  before_filter :user_login_required
  before_filter :admin_login_required, :only => [:index, :destroy]

  def new
    @feedback = Feedback.new
  end
  
  def create
    @feedback = current_user.feedbacks.new(params[:feedback])
    if @feedback.save
      flash[:notice] = "Your feedback was sent"
      redirect_to notice_url
    else
      render :action => 'new'
    end
  end
  
  def index
    @feedbacks = Feedback.all :order => "created_at DESC"
  end
end
