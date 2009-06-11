require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Newsletter do
  before(:each) do
    @valid_attributes = {:content => "This is the content of a newsletter"}
    ActionMailer::Base.deliveries = []
  end
  
  after(:each) do
    reset_everything
  end

  it "should create a new instance given valid attributes" do
    Newsletter.create!(@valid_attributes)
  end
  
  it "should return all subscribers and subscribed users as recipients" do
    10.times {|i| Factory(:user)}
    10.times {|i| Factory(:user, :subscribed => false)}
    10.times {|i| Subscriber.create! :email => "email_#{i}@email.com"}
    newsletter = Newsletter.create! @valid_attributes
    recipients = newsletter.recipients
    recipients.should == (User.subscribers.collect(&:email) + Subscriber.all.collect(&:email)).uniq
  end
  
  it "should send an email with send" do
    @newsletter = Factory(:newsletter)
    @newsletter.send_email
    ActionMailer::Base.deliveries.count.should == 1
  end
end
