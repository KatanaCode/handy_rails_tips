require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserObserver do
  before(:each) do      
    @valid_attributes = Factory.attributes_for(:user)
    ActionMailer::Base.deliveries = []
  end
  
  after(:each) do
    reset_everything
  end


  it "should send welcome email to users after creation" do
    Factory(:user)
    ActionMailer::Base.deliveries.count.should == 1
  end
  
  it "should destroy subscription if it has user email" do
    @subscription = Factory(:subscriber, :email => "emails@arecool.com" )
    @user = Factory(:user, :email => "emails@arecool.com")
    Subscriber.count.should == 0
  end
  
  it "should subscribe user if subscription exists and user is not subscribed" do
    @valid_attributes[:subscribed] = false
    @subscription = Subscriber.create! :email => @valid_attributes[:email]
    @user = User.create! @valid_attributes
    @user.subscribed.should be_true
  end
    
  

end
