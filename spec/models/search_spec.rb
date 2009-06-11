require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Search do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:search)
    ActionMailer::Base.deliveries = []
  end
  
  after(:each) do
    reset_everything
  end
  
  it "should create new search on occur if criterion has not been used" do
    @search = Search.occur :criterion => "chips"
    @search2 = Search.occur :criterion => "chips"
    @search2.id.should == @search.id
  end
  
  it "should return existing search on occur if criterion has been used" do
    @search = Search.occur :criterion => "chips"
    @search2 = Search.occur :criterion => "chips"
    @search2.id.should == @search.id
  end
  
  it "should be have success false by default" do
    @search = Factory.build(:search)
    @search.success.should be_false
  end
  
  it "should have frequency 1 by default" do
    @search = Factory.build(:search)
    @search.frequency.should == 1
  end
  
  it "should protect success from mass assignment" do
    @search = Search.new :success => true
    @search.success.should be_false
  end
  
  it "should protect frequency from mass assignment" do
    search = Search.new :frequency => 2, :criterion => "search"
    search.frequency.should == 1
  end
  
  it "should increment frequency when occurs" do
    criterion = "rails"
    @search = Search.occur(:criterion => criterion)
    10.times {Search.occur :criterion => criterion}
    @search.reload.frequency.should == 11 #was 1 to begin
  end
  
  it "should strip spaces from criterion before saving" do
    search = Search.occur :criterion => " search "
    search.criterion.should == "search"
  end
  
  it "should downcase criterion before saving" do
    search = Search.occur :criterion => " CAPS "
    search.criterion.should == "caps"
  end
  
  it "should mark success with mark_success" do
    @search = Factory(:search, :success => false)
    @search.mark_success
    @search.success.should == true
  end
  
  it "should return all tips with relevant tags" do
    @tip1 = Factory(:tip)
    @tip2 = Factory(:tip)
    @tip3 = Factory(:tip)
    @tip4 = Factory(:tip)
    @tip5 = Factory(:tip)
    @tip6 = Factory(:tip)
    tip_array = [@tip1, @tip2, @tip3]
    tip_array.map do |tip|
      tip.tag_list.add "tag"
      tip.save
    end
    @search = Factory(:search, :criterion => "TAG")
    @search.results.should == tip_array
  end
end