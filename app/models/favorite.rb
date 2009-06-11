class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :tip
  
  after_create :user_gains_kudos
  
  after_destroy :user_loses_kudos
  
  attr_protected :user_id
  
  validates_uniqueness_of :tip_id,
    :scope => :user_id,
    :message => 'has already been added to favorites'
    
  private
  
  def user_gains_kudos
    tip.user.gain_kudos
  end
  
  def user_loses_kudos
    tip.user.lose_kudos
  end
  
end
