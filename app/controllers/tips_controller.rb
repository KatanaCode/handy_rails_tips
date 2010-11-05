class TipsController < ApplicationController

  
  user_login_required :only => [:new,:create, :edit, :destroy, :update]
  
  caches_page :show
    
  def index
    respond_to do |format|
      format.html {
        @tips = Tip.paginate :per_page => 10, :page => params[:page] || 1
      }
      format.xml {
        @tips = Tip.select("id, title").all
        render :xml => @tips
      }
    end
  end
  
  def show
    @tip = Tip.find(params[:id])    
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
      expire_fragment(:controller => "tips", :action => "show", :id => @tip.id) # IMPORTANT!!!
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
  
  
  def preview
  end
end