require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedbackObserver do
  before(:each) do
    @user = Factory(:user)

    ActionMailer::Base.deliveries = []
  end
  
  after(:each) do
    reset_everything
  end
  
  it "should send an email after creating feedback" do
    feedback = @user.feedbacks.create! :message => "What a great site"
    ActionMailer::Base.deliveries.count.should == 1
  end
  
end
