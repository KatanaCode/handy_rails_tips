class User < ActiveRecord::Base  
  
  
  before_create :set_login_times
  before_create :set_token
  
  before_validation :downcase_username
  before_validation {|u| u.username.downcase! }
  
  before_save :hash_password  
    
  

  before_save :downcase_email
    
  has_many :favorites, :dependent => :destroy
  has_many :feedbacks
  has_many :tips, :include => :comments, :conditions => ['state != ?', STATES[:removed]], :dependent => :destroy
  has_many :votes
  
  attr_protected :kudos, :role, :last_login, :this_login, :salt, :token
  
  validates_presence_of :email
  validates_uniqueness_of :email, 
    :message => "has already been taken", 
    :ignore_case => true, :if => lambda {|user| user.errors.on(:email).nil?}
  validates_length_of :email, 
    :within => 8..50, 
    :if => lambda {|user| user.errors.on(:email).nil?}
  validates_format_of :email, 
    :with => EMAIL_FORMAT,
    :message => "doesn't look valid",
    :if => lambda {|user| user.errors.on(:email).nil?}
  
  validates_presence_of :username
  validates_uniqueness_of :username, 
    :message => "has already been taken", 
    :ignore_case => true, 
    :if => lambda {|user| user.errors.on(:username).nil?}
  validates_length_of :username, 
    :within => 4..15, 
    :if => lambda {|user| user.errors.on(:username).nil?}
  validates_format_of :username, 
    :with => /^[\w\d]+$/, 
    :message => "should only contain letters and numbers", 
    :if => lambda {|user| user.errors.on(:username).nil?}
    
  validates_presence_of :password, :if => :should_validate_password?
  validates_length_of :password, 
    :minimum => 6, 
    :if => lambda { |user| user.errors.on(:password).nil? && user.should_validate_password?}
  
  validates_confirmation_of :password, 
    :if => lambda {|user| user.errors.on(:password).nil? && user.should_validate_password? },
    :message => "wasn't the same the second time"
  
  validates_presence_of :password_confirmation, :if => :password_changed?  
  
  validates_acceptance_of :terms, :on => :create
  
  validates_format_of :url, 
    :with => URL_FORMAT, 
    :message => "doesn't look valid", :unless => lambda {|user| user.url.empty?}
  
  validates_format_of :working_with_rails_id, :allow_blank => true, :allow_nil => true, :with => WORKING_WITH_RAILS_FORMAT, :message => "doesn't look valid"
  validates_uniqueness_of :working_with_rails_id, :allow_blank => true, :case_sensitive => false,  :allow_nil => true, :message => "already taken"

  validates_format_of :twitter_username, :allow_blank => true,  :allow_nil => true, :with => TWITTER_UN_FORMAT, :message => "doesn't look valid"
  validates_uniqueness_of :twitter_username, :allow_blank => true,  :allow_nil => true, :case_sensitive => false, :message => "already taken"

  
  validates_permitted :username, :in => RESERVED_NAMES, :message => "is not available"
    
  named_scope :subscribers, :conditions => {:subscribed => true}
  
  attr_accessor :password
  attr_accessor :updating_password
  attr_accessor :old_password

  def has_twitter?
    twitter_username && twitter_username.length > 0
  end

  def has_wwr?
    working_with_rails_id && working_with_rails_id.length > 0
  end

  def reset_token
    update_attribute :token, make_token
  end
  
  def subscribe
    update_attribute :subscribed, true
  end
  
  def unsubscribe
    update_attribute :subscribed, false
  end
  
  def set_show_email_false
    update_attribute :show_email, false
    
  end
  
  def set_show_email_true
    update_attribute :show_email, true
  end
  
  def set_notify_me_false
    update_attribute :notify_me, false
  end
  
  def set_notify_me_true
    update_attribute :notify_me, true
  end
  
  def hash_password
    create_salt if salt.nil?
    if new_record? || updating_password == true 
      self.hashed_password = Digest::SHA2.hexdigest("#{salt}#{password.downcase}")
    end
  end
  
  def password_matches? password_to_match
     hashed_password == Digest::SHA2.hexdigest("#{salt}#{password_to_match.downcase}")
  end
  
  def admin?
    role == ROLES[:admin]
  end
  
  def turn_ajax_on
    update_attribute :use_ajax, true
  end
  
  def turn_ajax_off
    update_attribute :use_ajax, false
    
  end
  
  def should_validate_password?
      updating_password == true || new_record?
  end
  
  def hashed_email
    Digest::MD5.hexdigest(email)
  end
  
  def gain_kudos
    increment!(:kudos)
  end
  
  def lose_kudos
    decrement!(:kudos)
  end
  
  private
  
  def password_changed?
    self.changed.include? 'password'
  end
  
  def downcase_username
    self.username.downcase!
  end
  
  def downcase_email
    self.email.downcase!
    
  end
  
  def set_login_times
    time = Time.now
    self.this_login = time
    self.last_login = time
  end
  
  def set_token
    self.token = make_token
  end
  
  def make_token
    SecureRandom.hex(8)
  end
  
  def create_salt
    self.salt = random_numbers(8)
  end
  
  def random_numbers(no)
    numbers = ("0".."9").to_a
    newrand = ""
    1.upto(no) { |i| newrand << numbers[rand(numbers.size - 1)]}
    newrand
  end
end
