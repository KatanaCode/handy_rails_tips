class CommentsController < ApplicationController

  before_filter :admin_login_required, :only => :index
  
  def index
    states = %w(unflagged flagged allowed removed)
    @conditions = states.include?(params[:only]) ? ["state = ?", STATES[(params[:only].to_sym)]] : nil
    @comments = Comment.find :all, :conditions => @conditions, :order => 'tip_id ASC, created_at DESC'
  end
  
  # remove the exclaimations from both
  def create
    @tip = Tip.find params[:tip_id]
    @comment = @tip.comments.new params[:comment]
    if @comment.save_with_captcha
      session[:comments] = [] unless session[:comments]
      session[:comments] << @comment.id
      flash[:notice] = "Your comment was added"
      redirect_to tip_url(@tip) and return
    else
      @user = @tip.user # => required if re-rendering page
      @comments = @tip.comments
      render :template => "tips/show"
    end
  end
  
  def destroy
    @comment = Comment.find params[:id]
    @comment.destroy
    flash[:notice] = deleted_message("Comment")
    redirect_to comments_url
  end
  
  def flag
    @tip = Tip.find params[:tip_id]
    @comment = Comment.find params[:id]
    @comment.flag
    flash[:notice] = flagged_message("Comment")
    redirect_to @tip
  end
  
  def allow
    @comment = Comment.find params[:id]
    @comment.allow
    flash[:notice] = "Comment was allowed"
    redirect_to comments_url
  end
  
  def remove
    @comment = Comment.find params[:id]
    @comment.remove
    flash[:notice] = "Comment was removed"
    redirect_to comments_url
  end

end
