require 'rubygems'
require 'coderay'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tip do
  before(:each) do
    @user = Factory(:user)

    @valid_attributes = Factory.attributes_for(:tip, :user => @user)
    ActionMailer::Base.deliveries = []
       
  end
  
  after(:each) do
    reset_everything
  end
  
  it "should create a new instance given valid attributes" do
    Tip.create!(@valid_attributes)
  end
  
  it "should protect state from mass assignment" do
    tip = Tip.new :state => STATES[:allowed]
    tip.state.should == STATES[:unflagged]
  end
  
  it "should protect user_id from mass assignment" do
    tip = Tip.new :user_id => @user.id
    tip.user_id.should be_nil
  end
  
  it "should have many tags accessible through tag_list" do
    tip = Tip.create! @valid_attributes
    tip.tag_list.add("tag1", "tag2")
    tip.tag_list.count.should == 2
  end
  
  it "should not be valid without a title" do
    @tip = Tip.new
    @tip.valid?
    @tip.errors.on(:title).should == "can't be blank"
  end
  
  it "should not be valid if title is less than 6" do
    @valid_attributes[:title] = "short"
    @tip = Tip.new @valid_attributes
    @tip.valid?
    @tip.errors.on(:title).should == "is too short (minimum is 6 characters)"
  end
  
  it "should not be valid if title is longer than 80" do
    @valid_attributes[:title] = "aosidfjasoidjfaosidjfosadijfdosaijfosijfoaidsjfsaoijoijdaidjfsodifjsaodfsadifjsia"
    @tip = Tip.new @valid_attributes
    @tip.valid?
    @tip.errors.on(:title).should == "is too long (maximum is 80 characters)"
  end  

  it "should not be valid without a body" do
    @tip = Tip.new
    @tip.valid?
    @tip.errors.on(:body).should == "can't be blank"
  end
  
  it "should strip title of spaces before saving" do
    @valid_attributes[:title] = "  THis Title has too MANY SPACES  "
    @tip = Tip.create! @valid_attributes
    @tip.title.should == "THis Title has too MANY SPACES"
  end
  
  it "should change state to STATES[:flagged] when flagged" do
    @tip = Tip.create! @valid_attributes
    @tip.flag
    @tip.state.should == STATES[:flagged]
  end
  
  it "should change state to STATES[:allowed] when allowed" do
    @tip = Tip.create! @valid_attributes
    @tip.allow
    @tip.state.should == STATES[:allowed]
  end
  
  it "should change state to STATES[:removed] when removed" do
    @tip = Tip.create! @valid_attributes
    @tip.remove
    @tip.state.should == STATES[:removed]
  end
  
  it "should not belong to a user if it has been removed" do
    @tip = @user.tips.create! :title => 'this is my tip', :body => "This is the body of my tip"
    @tip.remove
    @user.tips.should be_empty
  end
  
  it "should destroy comments after destroy" do
    @tip = Tip.create! @valid_attributes
    10.times {@tip.comments.create! :name => "myname", :body=> "mycomment", :email => "email@email.com"}
    @tip.destroy
    Comment.count.should == 0
  end
  
  it "should set state to STATES[:unflagged] with mark unflagged" do
    @tip  = Factory(:tip, :state => STATES[:unflagged])
    @tip.mark_unflagged
    @tip.state.should == STATES[:unflagged]
  end
  
  it "should return boolean true for has_changed? if updated at is later than created at" do
    @tip = Factory(:tip, :created_at => 1.day.ago)
    @tip.flag
    @tip.has_changed?.should be_true
  end
  
  it "should return boolean false for has_changed? if updated at is equal to created at" do
    @tip = Factory(:tip)
    @tip.has_changed?.should be_false
  end
  
  it "should include the title in the address" do
    @tip = Factory(:tip)
    @tip.to_param.should == "#{@tip.id}-#{@tip.title.parameterize}"
  end
  
  it "should have a named scope called for_public" do
    STATES.each do |key, val|
      5.times { Factory(:tip, :state => val)}
    end
    Tip.for_public.should == Tip.find(:all, :conditions => ["state = ? OR state = ?", STATES[:unflagged], STATES[:allowed]], :order => "created_at DESC")
  end
  
  it "should be safe if state is unflagged" do
    @tip = Factory(:tip, :state => STATES[:unflagged])
    @tip.safe?.should be_true
  end
  it "should be safe if state is flagged" do
    @tip = Factory(:tip, :state => STATES[:flagged])
    @tip.safe?.should be_false
  end
  it "should be safe if state is allowed" do
    @tip = Factory(:tip, :state => STATES[:allowed])
    @tip.safe?.should be_true
  end
  it "should be safe if state is removed" do
    @tip = Factory(:tip, :state => STATES[:removed])
    @tip.safe?.should be_false
  end

end