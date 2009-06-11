require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Favorite do
  before(:each) do
    @user = Factory(:user)

      
    @tip  = Factory(:tip)
      
    @valid_attributes = Factory.attributes_for(:favorite)
    ActionMailer::Base.deliveries = []
    
  end
  
  after(:each) do
    reset_everything
  end

  it "should create a new instance given valid attributes" do
     @user.favorites.create! :tip => @tip
  end
   
  it "should belong to a user" do
    @favorite = @user.favorites.new
    @favorite.user.should == @user
  end
  
  it "should belong to a tip" do
    @favorite = @user.favorites.create! :tip => @tip
    @favorite.tip.should == @tip
  end
  
  it "should protect user_id from mass assignment" do
    @favorite = Favorite.new :user_id => @user.id
    @favorite.user_id.should be_nil
  end
    
  it "should not be valid if tip has already been favored" do
    @user.favorites.create! :tip => @tip
    @favorite2 = @user.favorites.new :tip => @tip
    @favorite2.valid?
    @favorite2.errors.on(:tip_id).should == "has already been added to favorites"
  end
  
  it "should add 1 to tip writer's kudos after create" do
    @author = Factory(:user)
    @tip = Factory(:tip, :user => @author)
    kudos_before = @author.kudos
    @favorite = Factory(:favorite, :user => @user, :tip => @tip)
    @author.reload.kudos.should == kudos_before+1
  end
  
  it "should subtract 1 from tip writer's kudos after destroy" do
    @author = Factory(:user)
    @tip    = Factory(:tip, :user => @author)
    @favorite = Factory(:favorite, :user => @user, :tip => @tip)
    kudos_before = @author.kudos
    @favorite.destroy
    @author.reload.kudos.should == kudos_before-1
  end
  
end
