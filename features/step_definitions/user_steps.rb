Given /^I have no users$/ do
  User.destroy_all
end


When /^I try to login as "([^\"]*)" with token "([^\"]*)"$/ do |username, token|
  user = User.find_by_username username
  get login_with_token_path(:id => user.id, :token => token)
end

When /^I try to login as "([^\"]*)" with "([^\"]*)" token$/ do |username, other_user|
  account = User.find_by_username(username)
  token   = User.find_by_username(other_user).token
  get login_with_token_path :id => account.id, :token => token
end

Then /^"([^\"]*)" should have (\d+) kudos points?$/ do |username, count|
  user = User.find_by_username username
  user.kudos.should == count.to_i
end