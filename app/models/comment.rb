require "#{Rails.root}/config/initializers/modules.rb"
require "#{Rails.root}/lib/validates_permitted"
class Comment < ActiveRecord::Base  
  include UrlSorter

  # TODO - fix me
  def self.validates_permitted(attribute, options = { :message => "is not permitted"})
    options.to_options!
    options.assert_valid_keys(:message, :in)
    raise ":in must be specified" if options[:in].nil?
    validate do |obj|
      options[:in].each do |reserved|
        obj.errors.add(attribute, options[:message]) if obj.send(attribute) == reserved
      end
    end
  end


  attr_protected :state, :tip_id
  
  before_validation :add_protocol
  before_save :strip_name
  
  
  belongs_to :tip
    
  validates_presence_of :name
  validates_length_of :name, 
    :within => 2..20, 
    :if => lambda { |comment| comment.errors.on(:name).nil? }

  validates_presence_of :email
  
  validates_length_of :email, 
    :within => 8..50, 
    :if => lambda { |comment| comment.errors.on(:email).nil? }
    
  validates_format_of :email, 
    :with => EMAIL_FORMAT, 
    :message => "doesn't look valid",
    :if => lambda { |comment| comment.errors.on(:email).nil? }
  
  validates_presence_of :body
  
  validates_format_of :url, 
    :with => URL_FORMAT, 
    :message => "doesn't look valid", :allow_blank => true
  
  validates_permitted :name, :in => RESERVED_NAMES
        
  named_scope :permitted, 
    :conditions => ['state IN (?)', [STATES[:unflagged], STATES[:allowed]]], 
    :order => 'created_at DESC'

      
  def safe?
    (state == STATES[:unflagged]) || (state == STATES[:allowed])
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
  
  protected
    
  def strip_name
    self.name.strip!
  end
  
end
