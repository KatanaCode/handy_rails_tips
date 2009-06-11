class UsersController < ApplicationController
  before_filter :admin_login_required, :only => [:index, :return_results]
  def index
    @users = User.all
  end
  
  def return_results
    @criterion = params[:q]
    @users = User.all :conditions => ["username LIKE ? OR email LIKE ?", "#@criterion%", "#@criterion%"]
    render :partial => "user", :collection => @users
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    if @user.save
      session[:user_id] = @user.id
      redirect_to my_profile_url
    else
      render :action => "new"
    end
  end
  
  def show
    @user = User.find params[:id]
    @tips = @user.tips
  end
  
  def edit
    @user = @current_user
  end
  
  def update
    @user = User.find params[:id]
    if params[:user][:old_password]
      if @user.password_matches? params[:user][:old_password]
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
        @user.updating_password = true
        if @user.save
          redirect_to my_profile_url
          flash[:notice] = saved_msg
        else
          render :action => :change_password
        end
      else
        @user.errors.add(:old_password, "was incorrect")
        render :action => :change_password
      end
    else
      @user.update_attributes params[:user]
      @user.updating_password = true if params[:user][:updating_password]
      if @user.save
        flash[:notice] = saved_msg
        redirect_to my_profile_url
      else
        render :action => "reset_password" if params[:user][:updating_password]
        render :action => "edit" unless params[:user][:updating_password]
      end
    end
  end
  
  def change_password
    @user = current_user
  end
  
  def reset_password
    @user = @current_user
  end
  
  def my_profile
    @user         = @current_user
    @mytips       = @user.tips.all
    @myfavorites  = @user.favorites.all
  end
  
  def destroy
    @user = User.find params[:id]
    name = @user.username
    @user.destroy
    flash[:notice] = deleted_message(name)
    redirect_to users_url
  end
  
  def change_ajax_opts
    if params[:hide] == "true"
      @current_user.turn_ajax_off
    else params[:hide] == "false"
      @current_user.turn_ajax_on
    end
    @current_user.reload
    render :partial => "tips/preview_options"
  end

end
