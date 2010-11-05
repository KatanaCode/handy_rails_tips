class User < ActiveRecord::Base  

  RESERVED_NAMES = %w( admin root handyrailstips webmaster )


  before_save :hash_password  

  has_many :tips


  validates_presence_of :username
  validates_uniqueness_of :username, :message => "has already been taken", :ignore_case => true

  validates_presence_of :password, :if => :should_validate_password?
  validates_length_of :password, :minimum => 6

  validates_confirmation_of :password, :if => :should_validate_password?

  validates_presence_of :password_confirmation, :if => :password_changed?  

  validates_acceptance_of :terms, :on => :create

  attr_accessor :password
  attr_accessor :updating_password
  attr_accessor :old_password

  def self.find_from_params( params )
    user = 
    case params[:username]
    when EMAIL_FORMAT then
      find_by_email params[:username]
    when /[\w]+/ then
      find_by_username params[:username]
    else
      nil
    end
    return user if user and user.password_matches? params[:password]
    nil
  end

  def hash_password
    create_salt unless salt
    if new_record? || updating_password == true 
      self.hashed_password = encrypt("#{salt}#{password.downcase}")
    end
  end

  def password_matches? password_to_match
    hashed_password == encrypt("#{salt}#{password_to_match.downcase}")
  end

  def should_validate_password?
    updating_password == true || new_record?
  end

  def encrypt( value )
    Digest::SHA2.hexdigest( value )
  end
  
  def hashed_email
    Digest::MD5.hexdigest(email)
  end

  private

  def password_changed?
    self.changed.include? 'password'
  end

  def set_token
    self.token = make_token
  end

  def make_token
    ActiveSupport::SecureRandom.hex(8)
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
