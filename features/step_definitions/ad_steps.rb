Given /^I have created ads$/ do |table|
  table.hashes.each do |hash|
    get new_ad_path
    fill_in "ad_company", :with => hash[:company]
    fill_in "ad_url", :with => hash[:url]
    attach_file("ad_image", File.join(RAILS_ROOT, 'public', 'images', 'art.png'))
    click_button "save ad"
  end
end