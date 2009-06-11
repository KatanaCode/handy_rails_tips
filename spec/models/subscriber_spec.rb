require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Subscriber do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:subscriber)
    ActionMailer::Base.deliveries = []
    
  end
  
  after(:each) do
    reset_everything
  end

  it "should create a new instance given valid attributes" do
    Subscriber.create!(@valid_attributes)
  end
  
  it "should not be valid if email is not unique" do
    Subscriber.create! @valid_attributes
    @sub2 = Subscriber.new @valid_attributes
    @sub2.valid?
    @sub2.errors.on(:email).should == "has already been added to mailing list"
  end
  
  it "should not be valid without email" do
    @subscriber = Factory.build(:subscriber, :email => "")
    @subscriber.valid?
    @subscriber.errors.on(:email).should == "can't be blank"
  end
  
  it "should not be valid with invalid email" do
    @subscriber = Factory.build(:subscriber, :email => "invalid")
    @subscriber.valid?
    @subscriber.errors.on(:email).should == "doesn't look valid"
  end
  
  it "should downcase email before saving" do
    @subscriber = Factory(:subscriber, :email => "uppERCASE@email.com")
    @subscriber.email.should == "uppercase@email.com"
  end
  
end
