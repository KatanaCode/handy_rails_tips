require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TipObserver do
  before(:each) { ActionMailer::Base.deliveries = [] }

  it "should send an email after saving if tip is flagged" do
    @tip = Factory(:tip)
    @tip.flag
    ActionMailer::Base.deliveries.count.should == 1
  end
  
end