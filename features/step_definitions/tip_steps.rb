Given /^user "([^\"]*)" has tips?$/ do |username, table|
  @user = User.find_by_username(username)
  table.hashes.each do |hash| 
    hash.merge!({:user => @user})
    Factory(:tip, hash)
  end
end


Given /^tip "([^\"]*)" has comments?$/ do |title, table|
  tip = Tip.find_by_title title
  table.hashes.each do |hash|
    hash.merge!({:tip => tip})
    Factory(:comment, hash)
  end
end

Given /^I have (\d+) tip records tagged with "([^\"]*)"$/ do |count, tags|
  count.to_i.times {Factory(:tip, :tag_list => tags)}
end

Then /^I should only see (\d+) tips$/ do |count|
  assigns(:tips).count.should == count.to_i
end

Then /^tip "([^\"]*)" should have (\d+) comments$/ do |title, count|
  Tip.find_by_title(title).comments.count.should == count.to_i
end