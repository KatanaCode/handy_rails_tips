Given /^I have (\d+) (\w+)$/ do |count, klass|
  count.to_i.times { Factory(klass.singularize) }
end

Given /^I have (\w+) records?$/ do |klass, table|
  table.hashes.each do |hash|
    Factory(klass, hash)
  end
end

Given /^I have (\d+) (\w+) records?$/ do |count, klass|
  count.to_i.times {Factory(klass)}
end

Given /^I am logged in as "([^\"]*)"$/ do |username|
  user = User.find_by_username username
  get login_path
  fill_in "username", :with => user.username
  fill_in "password", :with => "password"
  click_button "log in"
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |login, password|
  get login_path
  fill_in "username", :with => login
  fill_in "password", :with => password
  click_button "log in"
end

Given /^I am not logged in$/ do
  get logout_path
end

Then /^I should have (\d+) (\w+)$/ do |count, klass|
  klass.singularize.classify.constantize.count.should == count.to_i
end

Then /^variable "@([^\"]*)" should have (\d+) items$/ do |var, count|
  assigns(var.to_sym).count.should == count.to_i
end

Then /^I should have no errors on (\w+)$/ do |var_name|
  assigns(var_name.to_sym).errors.should be_empty
end