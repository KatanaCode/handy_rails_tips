require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
  before(:each) do
    @user = Factory(:user)
    @tip  = Factory(:tip)
    @valid_attributes = Factory.attributes_for(:comment)
    ActionMailer::Base.deliveries = []
  end
  
  after(:each) do
    reset_everything
  end

  it "should have a named scope called permitted" do
    20.times { |i| Factory(:comment, :tip => @tip) }
    Comment.all[5..9].each   {|comment| comment.flag}
    Comment.all[10..14].each {|comment| comment.allow}
    Comment.all[15..19].each {|comment| comment.remove}
    Comment.permitted.should == Comment.all(:conditions => ['state IN (?)', [STATES[:unflagged], STATES[:allowed]]], :order => 'created_at DESC')
  end

  it "should create a new instance given valid attributes" do
    @tip.comments.create!(@valid_attributes)
  end
  
  it "should not be valid without email" do
    @comment = Factory.build(:comment, :email => "")
    @comment.valid?
    @comment.errors.on(:email).should == "can't be blank"
  end
  
  it "should not be valid if email is longer than 50" do
    @comment = Factory.build(:comment, :email => "djsaofjoaisjdoij@sdoijoafijaosidfjosaidjfoasisd.com")
    @comment.valid?
    @comment.errors.on(:email).should == "is too long (maximum is 50 characters)"
  end
  
  it "should not be valid if email is shorter than 8" do
    @comment = Factory.build(:comment, :email => "a@a.com")
    @comment.valid?
    @comment.errors.on(:email).should == "is too short (minimum is 8 characters)"
  end
  
  it "should not be valid if email if not correct format" do
    @comment = Factory.build(:comment, :email => "invalidemailaddress")
    @comment.valid?
    @comment.errors.on(:email).should == "doesn't look valid"
  end
  
  it "should not be valid without name" do
    @comment = Factory.build(:comment, :name => "")
    @comment.valid?
    @comment.errors.on(:name).should == "can't be blank"
  end
  
  it "should not be valid if name is shorter than 2" do
    @comment = Factory.build(:comment, :name => "a")
    @comment.valid?
    @comment.errors.on(:name).should == "is too short (minimum is 2 characters)"
  end
  
  it "should not be valid if name is longer than 20" do
    @comment = Factory.build(:comment, :name => "afidoajfieiaouofosdfo")
    @comment.valid?
    @comment.errors.on(:name).should == "is too long (maximum is 20 characters)"
  end
  
  it "should strip extra spaces from name before save" do
    @comment = Factory(:comment, :name => " spacey ")
    @comment.name.should == "spacey"
  end
  
  it "should not be valid without a body" do
    @comment = Factory.build(:comment, :body => "")
    @comment.valid?
    @comment.errors.on(:body).should == "can't be blank"
  end
  
  it "should add protocol to url before save" do
    @comment = Factory(:comment, :url => "www.thinkersplayground.com" )
    @comment.url.should == "http://www.thinkersplayground.com"
  end
  
  it "should not add protocol to url before save if present" do
    @comment = Factory(:comment, :url => "http://www.thinkersplayground.com")
    @comment.url.should == "http://www.thinkersplayground.com"
  end
  
  it "should not add protocol to url if url is blank" do
    @comment = Factory(:comment, :url => "")
    @comment.url.should == ""
  end
    
  it "should not be valid if url is not a valid url" do
    @comment = Factory.build(:comment, :url => "not a url")
    @comment.valid?
    @comment.errors.on(:url).should == "doesn't look valid"
  end
  
  it "should belong to a tip" do
    @comment = @tip.comments.new
    @comment.tip.should == @tip
  end
  
  it "should have a default state of UNFLAGGED" do
    @comment = Factory.build(:comment)
    @comment.state.should == STATES[:unflagged]
  end
  
  it "should protect tip_id from mass assignment" do
    comment = Comment.new :tip_id => @tip.id
    comment.tip_id.should be_nil
  end
  
  it "should protect state from mass assignment" do
    comment = Comment.new :name => "joe bloggs", :email => "valid@email.com", :state => 4
    comment.state.should == 1
  end
  
  it "should change state to flagged when flagged" do
    @comment = Factory(:comment, :tip => @tip)
    @comment.flag
    @comment.state.should == STATES[:flagged]
  end
  
  it "should change state to allowed when allowed" do
    @comment = Factory(:comment, :tip => @tip)
    @comment.allow
    @comment.state.should == STATES[:allowed]
  end
  
  it "should change state to removed when removed" do
    @comment = Factory(:comment, :tip => @tip)
    @comment.remove
    @comment.state.should == STATES[:removed]
  end
  
  it "should not belong to tip if it has been removed" do
    @comment = Factory(:comment, :tip => @tip)
    @comment.remove
    @tip.comments.should be_empty
  end
  
  it "should be safe if state is unflagged" do
    @comment = Factory(:comment, :state => STATES[:unflagged])
    @comment.safe?.should be_true
  end
  it "should be safe if state is flagged" do
    @comment = Factory(:comment, :state => STATES[:flagged])
    @comment.safe?.should be_false
  end
  it "should be safe if state is allowed" do
    @comment = Factory(:comment, :state => STATES[:allowed])
    @comment.safe?.should be_true
  end
  it "should be safe if state is removed" do
    @comment = Factory(:comment, :state => STATES[:removed])
    @comment.safe?.should be_false
  end
end
