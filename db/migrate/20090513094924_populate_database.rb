class PopulateDatabase < ActiveRecord::Migration
  def self.up
    # user = User.new :username => "admin", :password => "bounce", :email => "admin@thinkersplayground.com"
    # user.role = ROLES[:admin]
    # user.save
    # User.create! :username => "user", :password => "bounce", :email => "user@thinkersplayground.com"
    # user = User.create! :username => "newuser", :password => "bounce", :email => "newuser@thinkersplayground.com"
    # user.tips.create! :title => 'An awesome tip', :body => "This is the body of my tip", :tag_list => "tip, one, two"
    # user.tips.create! :title => 'Another awesome tip', :body => "This is the body of my other tip", :tag_list => "tip, two, three"
  end

  def self.down
  end
end
