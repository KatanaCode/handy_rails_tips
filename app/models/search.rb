class Search < ActiveRecord::Base
  attr_protected :frequency, :success
    
  def self.occur(attributes = {})
    raise "Search criterion can't be nil" if attributes[:criterion].nil?
    crit = attributes[:criterion].downcase.strip
    search = find_by_criterion(crit)
    search.nil? ? search = Search.create!(:criterion => crit) : search.increment!(:frequency)
    search
  end
  

  
  def mark_success
    update_attribute(:success, true) unless success
  end
  
  def results
    Tip.find_tagged_with(criterion)
  end


end
