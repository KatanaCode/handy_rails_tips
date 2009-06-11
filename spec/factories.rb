Factory.define :ad do |t|
  t.url "http://mycompanyurl.com"
  t.company "Company"
  t.image { ActionController::TestUploadedFile.new("#{RAILS_ROOT}/public/images/art.png", "image/png")}
end

Factory.define :comment do |t|
  t.body "this is the <code>def right_way\n  puts 'right way'\nend</code> to do it!"
  t.url "http://mycoolurl.com"
  t.sequence(:email)  {|n| "user#{n}@email.com"}
  t.sequence(:name)   {|n| "Bob#{n}"}
  t.association(:tip)
end

Factory.define :favorite do |t|
  t.association(:user)
  t.association(:tip)
end

Factory.define :feedback do |t|
  t.association(:user)
  t.message "this is the message from my feedback"
end

Factory.define :newsletter do |t|
  t.content "This is the content of the newsletter"
end

Factory.define :search do |t|
  t.sequence(:criterion) {|n| "lookfor#{n}"}
end

Factory.define :subscriber do |t|
  t.sequence(:email) {|n| "email#{n}@address.com"}
end

Factory.define :tip do |t|
  t.sequence(:title) {|n| "this is my tip about #{n}"}
  t.body SAMPLE_TIP
  t.association(:user)
end

Factory.define :user do |t|
  t.sequence(:username) { |n| "user_#{n}_"}
  t.sequence(:email) { |n| "user_#{n}_email@email.com"}
  t.password "password"
  t.password_confirmation {|user| user.password }
  t.url "http://myurl.com"
  t.show_email true
  t.subscribed true
  t.notify_me true
  t.role ROLES[:standard]
end