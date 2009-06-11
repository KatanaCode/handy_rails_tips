Given /^user "([^\"]*)" has feedbacks$/ do |username, table|
  @user = User.find_by_username username
  table.hashes.each do |hash|
    hash.merge!({:user => @user})
    Factory(:feedback, hash)
  end
end