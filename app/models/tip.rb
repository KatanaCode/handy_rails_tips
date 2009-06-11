class Tip < ActiveRecord::Base    
  acts_as_taggable
  
  before_save :strip_spaces_from_title
  
  belongs_to :user

  has_many :comments, :dependent => :destroy, :conditions => ['state != ?', STATES[:removed]], :order => "created_at DESC"

  attr_protected :state, :user_id
  
  validates_presence_of :body
  validates_presence_of :title
  validates_uniqueness_of :title, :if => lambda {|tip| tip.errors.on(:title).nil?}
  validates_length_of :title, 
    :within => 6..80, 
    :if => lambda {|tip| tip.errors.on(:title).nil?}

  named_scope :for_public, :conditions => ["state = ? OR state = ?", STATES[:unflagged], STATES[:allowed]], :order => "created_at DESC"

  def to_param
    "#{id}-#{title.parameterize}"
  end
  
  def mark_unflagged
    update_attribute :state, STATES[:unflagged]
  end
  
  def flag
    self.state = STATES[:flagged]
    self.save
  end  
  
  def allow
    update_attribute :state, STATES[:allowed]
  end
  
  def remove
    update_attribute :state, STATES[:removed]
  end

  
  def has_changed?
    created_at.to_date != updated_at.to_date
  end
  
  def safe?
    (state == STATES[:unflagged]) || (state == STATES[:allowed])
  end
  
  def short_body
    body[0..400]
  end

  protected

  def strip_spaces_from_title
    self.title.strip!
  end
  
end