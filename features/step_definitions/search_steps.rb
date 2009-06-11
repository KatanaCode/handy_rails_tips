Then /^"([^\"]*)" should have been searched (\d) times?$/ do |criterion, count|
  @search = Search.find_by_criterion(criterion)
  @search.frequency.should == count.to_i
end

Then /^"([^\"]*)" should be an? (\w+) search$/ do |criterion, success|
  @search = Search.find_by_criterion(criterion)
  if success == "successful"
    @search.success.should be_true  
  elsif success == "unsuccessful"
    @search.success.should be_false
  end
end
