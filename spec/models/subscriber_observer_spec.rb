require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubscriberObserver do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:subscriber)
    ActionMailer::Base.deliveries = []
  end
  
  after(:each) do
    reset_everything
  end


  it "should send a subscriber email after create if subscriber is new" do
    Subscriber.create!(@valid_attributes)
    ActionMailer::Base.deliveries.count.should == 1
  end
  
  it "should update user to subscribed if email exists on user" do
    email = "thisis@email.com"
    @user = Factory(:user, :email => email)
    @subscriber = Factory(:subscriber, :email => email)
    @user.reload.subscribed.should be_true
    
  end
  
  it "should delete self if user exists with same email" do
    email = "thisis@email.com"
    @user = Factory(:user, :email => email)
    @subscriber = Factory(:subscriber, :email => email)
    Subscriber.count.should == 0
  end
end