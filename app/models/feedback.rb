class Feedback < ActiveRecord::Base
  belongs_to :user
  
  attr_protected :user_id
  
  validates_presence_of :user_id
  
  validates_presence_of :message
end
