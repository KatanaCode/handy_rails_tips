class TipsController < ApplicationController

  user_login_required :only => [:new,:create, :edit, :destroy, :update]  

  def index
    respond_to do |format|
      format.html {        
        @tips = Tip.paginate :per_page => 5, :page => params[:page] || 1
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
      redirect_to @tip,:notice => "Successfully created tip"
    else
      render :new
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
      redirect_to @tip, :notice => "Successfully updated tip"
    else
      render :edit
    end
  end

  def destroy
    @tip = Tip.find(params[:id])
    @tip.destroy
    redirect_to tips_url, :notice => "Successfully destroyed tip"
  end

end