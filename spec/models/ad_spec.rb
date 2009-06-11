require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'RMagick'
include Magick

describe Ad do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:ad)
    ActionMailer::Base.deliveries = []
  end
  
  after(:each) do
    reset_everything
  end

  it "should create a new instance given valid attributes" do
    Ad.create!(@valid_attributes)
  end
  
  it "should not be valid without url" do
    @ad  = Factory.build(:ad, :url => "") 
    @ad.valid?
    @ad.errors.on(:url).should == "can't be blank"
  end
  
  it "should not be valid without company" do
    @ad  = Factory.build(:ad, :company => "") 
    @ad.valid?
    @ad.errors.on(:company).should == "can't be blank"
  end
    
  it "should not be valid without image" do
    @ad  = Factory.build(:ad, :image => "") 
    @ad.valid?
    @ad.errors.on(:image).should == "can't be blank"
  end
  
  it "should save image to ads folder with id.png for name after create" do
    @ad = Factory(:ad)
    File.exist?("#{RAILS_ROOT}/public/images/ads/#{@ad.id}.png").should be_true
  end
  
  it "should update image after save if image was changed" do
    @ad = Factory(:ad)
    @ad.update_attributes(:company => "othercompany", :image => File.open("#{RAILS_ROOT}/public/images/rails.png"))
    Image.read("#{RAILS_ROOT}/public/images/ads/#{@ad.id}.png").first.columns.should < Ad::WIDTH
  end
    
  it "should save image with a width of 160px" do
    @ad = Factory(:ad)
    image = Image.read("#{RAILS_ROOT}/public/images/ads/#{@ad.id}.png").first
    image.columns.should == Ad::WIDTH
  end
  
  it "should return the path of the image as image_path" do
    @ad = Factory(:ad)
    @ad.image_path.should == "ads/#{@ad.id}.png"
  end
  
  it "should delete image upon destroy" do
    @ad = Factory(:ad)
    id = @ad.id
    @ad.destroy
    File.exist?("#{RAILS_ROOT}/public/images/#{id}.png").should be_false
  end
  
  it "should strip spaces from company before save" do
    @ad = Factory(:ad, :company => " spacey " )
    @ad.company.should == "spacey"
  end
  
  it "should add protocol to url before save" do
    @ad = Factory(:ad, :url => "www.thinkersplayground.com" )
    @ad.url.should == "http://www.thinkersplayground.com"
  end
  
  it "should not add protocol to url before save if present" do
    @ad = Factory(:ad, :url => "http://www.thinkersplayground.com")
    @ad.url.should == "http://www.thinkersplayground.com"
  end
  

end
