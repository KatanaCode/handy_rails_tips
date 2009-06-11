class SearchesController < ApplicationController
  before_filter :admin_login_required, :only => :index
  
  def index
    only = params[:only]
    @conditions = %w(successful unsuccessful).include?(only) ? {:success => (only == 'successful')} : nil
    @searches = Search.all :order => 'criterion ASC', :conditions => @conditions
  end
  
  def create
    redirect_to root_url and return if params[:search][:criterion].empty? || params[:search][:criterion] == "search keyword"
    @search = Search.occur :criterion => params[:search][:criterion]
    redirect_to search_url(:criterion => @search.criterion)
  end
  
  def show
    @this_search = Search.find_by_criterion(params[:criterion])
    @results = @this_search.results
    if @results.any?
      @this_search.mark_success
    end
  end

end
