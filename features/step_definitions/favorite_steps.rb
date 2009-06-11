Given /^user "([^\"]*)" has favorites?$/ do |username, table|
  @user = User.find_by_username(username)
  table.hashes.each do |hash| 
    @tip = Factory(:tip, hash)
    Factory(:favorite, :tip => @tip, :user => @user)
  end
end