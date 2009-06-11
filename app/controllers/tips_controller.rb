class TipsController < ApplicationController
  before_filter :user_login_required, :only => [:new,:create, :edit, :destroy, :update]
  skip_before_filter :fetch_ads, :only => [:change_ajax_opts, :preview]
  
  def index
    if current_user && current_user.admin?
      @tips = Tip.paginate :all, :per_page => 10, :page => params[:page] || 1, :order => "created_at DESC"
    else
      @tips  = Tip.for_public.paginate :all, :per_page => 10, :page => params[:page] || 1
    end
  end
  
  def show
    @tip = Tip.find(params[:id])
    @user = @tip.user
    @comment = Comment.new
    @comments = @tip.comments
    @session_comments = session[:comments] ? Comment.find(session[:comments]) : nil
    @favorite = Favorite.find :first, :conditions => {:user_id => current_user.id, :tip_id => @tip.id} if logged_in?
    return if @tip.safe?
    admin_logged_in? ? return : redirect_to(notice_url)
    flash[:warning] = flagged_message("tip")
  end
  
  def new
    @tip = Tip.new
  end
  
  def create
    @tip = current_user.tips.new(params[:tip])
    
    if @tip.save
      flash[:notice] = "Successfully created tip"
      redirect_to @tip
    else
      render :action => 'new'
    end
  end
  
  def edit
    @tip = Tip.find(params[:id])
    this_user_login_required @tip.user
  end
  
  def update
    @tip = Tip.find(params[:id])
    if @tip.update_attributes(params[:tip])
      @tip.mark_unflagged
      flash[:notice] = "Successfully updated tip"
      redirect_to @tip
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @tip = Tip.find(params[:id])
    @tip.destroy
    flash[:notice] = "Successfully destroyed tip"
    redirect_to tips_url
  end
  
  def flag
    @tip = Tip.find params[:id]
    @tip.flag
    flash[:notice] = "#{flagged_message('tip')} - thanks for your help"
    redirect_to notice_url
  end
  
  def allow
    @tip = Tip.find params[:id]
    @tip.allow
    flash[:notice] = "This tip has been allowed"
    redirect_to @tip
  end
  
  def remove
    @tip = Tip.find params[:id]
    @tip.remove
    flash[:notice] = "Tip removed."
    redirect_to tips_url if admin_logged_in?
    redirect_to my_profile_url unless admin_logged_in?
  end
  
  def change_ajax_opts
    
  end
  
  def preview
  end
end
