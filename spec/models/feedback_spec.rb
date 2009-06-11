require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Feedback do
  before(:each) do
    @user = Factory(:user)
    @valid_attributes = Factory(:feedback)
    ActionMailer::Base.deliveries = []
  end
  
  after(:each) do
    reset_everything
  end
  
  it "should create a new instance given valid attributes" do
    @user.feedbacks.create! :message => "this is my feedback to you"
  end
  
  it "should not be valid without user" do
    @feedback = Factory.build(:feedback, :user => nil)
    @feedback.valid?
    @feedback.errors.on(:user_id).should == "can't be blank"
  end
  
  it "should protect user_id from mass assignment" do
    @feedback = Feedback.new :user_id => @user.id
    @feedback.user_id.should be_nil
  end
  
  it "should not be valid without message" do
    @feedback = Factory.build(:feedback, :message => "")
    @feedback.valid?
    @feedback.errors.on(:message).should == "can't be blank"
  end

  

end
