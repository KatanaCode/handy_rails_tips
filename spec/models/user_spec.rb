require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @user = Factory(:user)
    @tip  = Tip.create!(:title => 'this is a title', 
      :body => "this is the body of the txt",
      :user => @user)
      
    @valid_attributes = Factory.attributes_for(:user)
    ActionMailer::Base.deliveries = []
    
  end
  
  after(:each) do
    reset_everything
  end
  
  it "should create a new instance given valid attributes" do
    user = User.create!(@valid_attributes)
  end
  
  it "should set the about column by default" do
    @user.about.should == "I haven't written anything here yet."
  end
  
  it "should create an 8 digit salt before creation" do
    @user.salt.should =~ /[0-9]{8}/
  end
 
  it "should set this_login upon create" do
    @user.this_login.should_not be_nil
  end
 
  it "should set last_login and last_login upon create" do
    @user.last_login.should_not be_nil
  end
  
  it "should set use_ajax to boolean true by default" do
    @user.use_ajax.should be_true
  end
  
  it "should set use_ajax to false with turn_ajax_off" do
    @user.turn_ajax_off
    @user.use_ajax.should be_false
  end
  
  it "should set use_ajax to true with turn_ajax_on" do
    @user = Factory(:user, :use_ajax => false)
    @user.turn_ajax_on
    @user.use_ajax.should be_true
  end
  
  it "should hash the password and salt with SHA2" do
    @user.hashed_password.should == Digest::SHA2.hexdigest("#{@user.salt}#{@user.password.downcase}")
  end

  it "should add protocol to url before save" do
    @user = Factory(:user, :url => "www.thinkersplayground.com" )
    @user.url.should == "http://www.thinkersplayground.com"
  end
  
  it "should not add protocol to url before save if present" do
    @user = Factory(:user, :url => "http://www.thinkersplayground.com")
    @user.url.should == "http://www.thinkersplayground.com"
  end
  
  it "should not add protocol to url if url is blank" do
    @user = Factory(:user, :url => "")
    @user.url.should == ""
  end
  
  it "should return boolean false if password_matches? password doesnt match" do
    @user.password_matches?("wrong_word").should_not be_true
  end
  
  it "should return boolean true if password_matches? password matches" do
    @user.password_matches?(@user.password).should be_true
  end
  
  it "should not be valid without an email" do
    @user = Factory.build(:user, :email => "")
    @user.valid?
    @user.errors.on(:email).should == "can't be blank"
  end
  
  it "should not be valid if email has been taken" do
    @user2 = Factory.build(:user, :email => @user.email)
    @user2.valid?
    @user2.errors.on(:email).should == "has already been taken"
  end
  
  it "should downcase email before saving" do
    @user = Factory(:user, :email => "CAPS@email.com")
    @user.email.should == "caps@email.com"
  end
  
  it "should downcase username before saving" do
    @user = Factory(:user, :username => "USERNAME")
    @user.username.should == "username"
  end
  
  it "should downcase password before encryption" do
    @user = Factory(:user, :password => "PASSWORD")
    @user.hashed_password.should == Digest::SHA2.hexdigest("#{@user.salt}#{@user.password.downcase}")
  end
  
  it "should find password_matches regardless of case" do
    @user.password_matches?(@user.password.upcase).should be_true
  end
  
  it "should validate the format of email" do
    @user = Factory.build(:user, :email => "wrong format")
    @user.valid?
    @user.errors.on(:email).should == "doesn't look valid"
  end
  
  it "should not be valid if email is shorter than 8" do
    user = Factory.build(:user, :email => "g@g.com")
    user.valid?
    user.errors.on(:email).should == "is too short (minimum is 8 characters)"
  end
  
  it "should not be valid if email is longer than 50" do
    user = Factory.build(:user, :email => "reallylongemailaddress@emailsthataretoolong.commmmm")
    user.valid?
    user.errors.on(:email).should == "is too long (maximum is 50 characters)"
  end
  
  it "should not be valid if username has been taken" do
    user1 = User.create! @valid_attributes
    user2 = User.create @valid_attributes
    user2.errors.on(:username).should == "has already been taken"
  end
  
  it "should not be valid without username" do
    user = Factory.build(:user, :username => "")
    user.valid?
    user.errors.on(:username).should == "can't be blank"
  end
  
  it "should not be valid if username is shorter than 4" do
    @user = Factory.build(:user, :username => "dog")
    @user.valid?
    @user.errors.on(:username).should == "is too short (minimum is 4 characters)"
  end
  
  it "should not be valid if username is longer than 15" do
    user = Factory.build(:user, :username => "oasidjfaaoaisjfa")
    user.valid?
    user.errors.on(:username).should == "is too long (maximum is 15 characters)"
  end
  
  it "should not be valid if username has spaces" do
    @user = Factory.build(:user, :username => "space man")
    @user.valid?
    @user.errors.on(:username).should == "should only contain letters and numbers"
  end
  
  it "should not be valid without passsword" do
    @user = Factory.build(:user, :password => "")
    @user.valid?
    @user.errors.on(:password).should == "can't be blank"
  end
  
  
  it "should not be valid if password is less than 6 chars" do
    @user = Factory.build(:user, :password => "asdas")
    @user.valid?
    @user.errors.on(:password).should == "is too short (minimum is 6 characters)"
  end

  it "should have many tips" do
    user = User.create! @valid_attributes
    tip = user.tips.new
  end
  
  it "should have many favorites" do
    user = User.create! @valid_attributes
    user.favorites.create! :tip => @tip
    user.favorites.first.tip.should == @tip
  end
  
  it "should have a named scope called subscribers to return subscribed users" do
    @user1 = Factory(:user)
    @user2 = Factory(:user, :subscribed => false)
    @user3 = Factory(:user)
    User.subscribers == User.find_by_subscribed(true)
  end
    
  it "should set notify_me to false with set_notify_me_false" do
    user = User.create! @valid_attributes
    user.set_notify_me_false
    user.notify_me.should_not be_true
  end
  
  it "should set notify_me to true with set_notify_me_true" do
    user = User.new @valid_attributes
    user.notify_me = false
    user.save
    user.set_notify_me_true
    user.notify_me.should be_true
  end
  
  it "should set show_email to false with set_show_email_false" do
    @user.set_show_email_false
    @user.show_email.should be_false
  end
  
  it "should set show_email to true with set_show_email_true" do
    user = User.new @valid_attributes
    user.show_email = false
    user.save
    user.set_show_email_true
    user.show_email.should be_true
  end
  
  it "should set subscribed false with unsubscribe" do
    user = User.create! @valid_attributes
    user.unsubscribe
    user.subscribed.should be_false
  end
  
  it "should set subscribed true with subscribe" do
    user = User.new @valid_attributes
    user.subscribed = false
    user.save
    user.subscribe
    user.subscribed.should be_true
  end
  
  it "should protect kudos from mass assignment" do
    user = User.new :kudos => 500
    user.kudos.should == 0
  end
  
  it "should protect role from mass assignment" do
    user = User.new :role => 1
    user.role.should == 2
  end
  
  it "should protect last_login from mass assignment" do
    user = User.new :last_login => 1.week.ago
    user.last_login.should be_nil
  end
  
  it "should protect this_login from mass assignment" do
    user = User.new :this_login => 1.week.ago
    user.this_login.should be_nil
  end
  
  it "should protect salt from mass assignment" do
    user = User.new :salt => 55533322
    user.salt.should_not == 55533322
  end
  
  it "should generate a random 16 char hex token at create" do
    @user.token.should =~ /[a-z0-9]{16}/i
  end
  
  it "should protect token from mass assignment" do
    @user = User.new :token => "AS1256BAfb125676"
    @user.token.should == ""
  end
  
  it "should create a new token with reset_token" do
    token = @user.token
    @user.reset_token
    @user.token.should_not == token
  end
  
  it "should not hash password at update updating_password = false" do
    original_pass = @user.hashed_password
    @user.update_attributes :email => "boo@boo.com"
    @user.hashed_password.should == original_pass
  end
  
  it "should hash password at update if updating password  = true" do
    @user.updating_password = true
    @user.update_attributes Factory.attributes_for(:user, :email => "hello@email.com", :password => 'newpassword')
    @user.hashed_password.should == Digest::SHA2.hexdigest("#{@user.salt}newpassword")
  end
  
  it "should destroy favorites after destroy" do
    @user.favorites.create! :tip => @tip
    @user.destroy
    Favorite.count.should == 0
  end
  
  it "should destroy tips after destroy" do
    @tip = @user.tips.create! :title => "this is the title", :body => "this is the body"
    @user.destroy
    Tip.count.should == 0
  end
  
  it "should return boolean true if admin?" do
    @user = Factory(:user, :role => ROLES[:admin])
    @user.admin?.should be_true
  end
  
  it "should return boolean false if not admin?" do
    @user = Factory(:user, :role => ROLES[:standard])
    @user.admin?.should be_false
  end
  
  it "should not validate password if it hasn't changed" do
    @user = User.first
    @user.email     = "new@emailaddress.com"
    @user.username  = "newusername"
    @user.save!
  end
  
  it "should hash email using MD5 with hashed_email" do
    @user.hashed_email.should == Digest::MD5.hexdigest(@user.email)
  end
  
  it "should not be valid if username is admin" do
    user = Factory.build :user, :username => "admin"
    user.valid?
    user.errors.on(:username).should == "is not available"
  end

  it "should not be valid if username is root" do
    user = Factory.build :user, :username => "root"
    user.valid?
    user.errors.on(:username).should == "is not available"
  end
  
  it "should not be valid if username is handyrailstips" do
    user = Factory.build :user, :username => "handyrailstips"
    user.valid?
    user.errors.on(:username).should == "is not available"
  end
  
  it "should not be valid if username is webmaster" do
    user = Factory.build :user, :username => "webmaster"
    user.valid?
    user.errors.on(:username).should == "is not available"
  end
  
  it "should not be valid if working_with_rails_id is not correct format" do
    user = Factory.build(:user, :working_with_rails_id => 'wrong!')
    user.valid?
    user.errors.on(:working_with_rails_id).should == "doesn't look valid"
  end
  
  it "should not be valid if twitter usename is not correct format" do
    user = Factory.build(:user, :twitter_username => "tes@$-")
    user.valid?
    user.errors.on(:twitter_username).should == "doesn't look valid"
  end
  
  it "should not be valid if working_with_rails_id has already been taken" do
    user = Factory(:user)
    new_user = Factory.build(:user, :working_with_rails_id => user.working_with_rails_id)
    new_user.valid?
    new_user.errors.on(:working_with_rails_id).should == "already taken"
  end
  
  it "should not be valid if twitter_usename has already been taken" do
    user = Factory(:user)
    new_user = Factory.build(:user, :twitter_username => user.twitter_username)
    new_user.valid?
    new_user.errors.on(:twitter_username).should == "already taken"
  end
  
  it "should return true if has twitter" do
    user = Factory(:user, :twitter_username => "valid")
    user.has_twitter.should == true
  end
  
  it "should return false from has_twitter if doesn't have twitter" do
    user = Factory(:user, :twitter_username => "")
    user.has_twitter.should == false
  end
  
  it "should return true if has wwr" do
    user = Factory(:user, :working_with_rails_id => "123-valid")
    user.has_twitter.should == true
  end
  
  it "should return false from has_wwr if doesn't have wwr" do
    user = Factory(:user, :working_with_rails_id => "")
    user.has_twitter.should == false
  end

end