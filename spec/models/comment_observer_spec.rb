require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentObserver do
  before(:each) do
    @user = Factory(:user)
    @tip  = Factory(:tip, :user => @user)    
  end
  after(:each) do
    reset_everything
    ActionMailer::Base.deliveries = []
  end

  it "should send an email to tip user after creation" do
    @comment = Factory(:comment, :tip => @tip)
    ActionMailer::Base.deliveries.count.should == 1
  end
  
  it "should not send email if user notify_my is false" do
    @user.set_notify_me_false
    @comment = Factory(:comment, :tip => @tip)
    ActionMailer::Base.deliveries.should be_empty
  end
  
  it "should send an email after saving if comment is flagged" do
    @comment = Factory(:comment)
    @comment.flag
    ActionMailer::Base.deliveries.count.should == 1
  end
  
end