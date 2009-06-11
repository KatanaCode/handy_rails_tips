class AdsController < ApplicationController
  before_filter :admin_login_required
  
  def index
  end
  
  def new
    @ad = Ad.new
  end
  
  def create
    @ad = Ad.new(params[:ad])
    if @ad.save
      flash[:notice] = "Successfully created Ad."
      redirect_to ads_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @ad = Ad.find(params[:id])
  end
  
  def update
    @ad = Ad.find(params[:id])
    if @ad.update_attributes(params[:ad])
      flash[:notice] = "Successfully updated Ad."
      redirect_to ads_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @ad = Ad.find(params[:id])
    @ad.destroy
    flash[:notice] = deleted_message "Ad"
    redirect_to ads_url
  end
end
