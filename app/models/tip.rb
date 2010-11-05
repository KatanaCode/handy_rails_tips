class Tip < ActiveRecord::Base    
  
  acts_as_taggable
  
  before_save :strip_spaces_from_title
  
  belongs_to :user
  
  attr_protected :user_id
  
  validates_presence_of :body,:title
  validates_uniqueness_of :title
  validates_length_of :title, :within => 6..80

  default_scope order("created_at DESC")

  def to_param
    "#{id}-#{title.parameterize}"
  end
  
  def has_changed?
    created_at.to_date != updated_at.to_date
  end
  
  
  def short_body
    body[0..400]
  end

  protected

  def strip_spaces_from_title
    self.title.strip!
  end
  
end