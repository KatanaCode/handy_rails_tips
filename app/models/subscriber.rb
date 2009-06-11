class Subscriber < ActiveRecord::Base
  
  before_validation :downcase_email
  
  
  validates_presence_of :email

  validates_format_of :email, :with => EMAIL_FORMAT, 
    :message => "doesn't look valid",
    :if => lambda {|subscriber| subscriber.errors.on(:email).nil? }
    
  validates_uniqueness_of :email, :message => "has already been added to mailing list", 
    :ignore_case => true,
    :if =>  lambda {|subscriber| subscriber.errors.on(:email).nil?}
    
  private
  
  def downcase_email
    self.email.downcase!
  end

end
