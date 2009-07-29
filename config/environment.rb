RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.load_paths += %W( #{RAILS_ROOT}/app/observers )
  config.gem "rmagick", :lib => false, :version => '>=2.9.1'
  config.gem 'will_paginate', :version => '~>2.2.2', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem "RedCloth", :version => ">=4.1.9", :lib => false, :source => "http://code.whytheluckystiff.net/redcloth/"
  config.gem "coderay", :version => ">=0.8.312", :lib => false, :source => 'http://gems.github.com'
  config.gem "rspec-rails", :lib => false, :version => '>=1.2.2'
  config.gem "rspec", :lib => false, :version => '>=1.2.2'
  config.gem "webrat", :lib => false, :version => '>=0.4.3'
  config.gem "ZenTest", :lib => false, :version => '>=4.0.0'
  config.gem "redgreen", :lib => false, :version => ">=1.2.2"
  config.gem "cucumber", :lib => false, :version => '>=0.2.3'
  config.gem "mocha", :lib => false, :version => '>=0.9.5'
  config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
  config.gem "markaby", :version => ">=0.5"
  config.gem "less", :version => ">=0.8.9"
  
  config.plugins = [ :all ]
  
  Dir.chdir("#{Rails.root}/app/observers") do
    config.active_record.observers = Dir.glob("*_observer.rb").collect {|ob_name| ob_name.split(".").first}
  end

  config.time_zone = 'UTC'
  
  config.action_controller.session = {
    :session_key => '_tips_session',
    :secret      => 'ab25d67b0823ee1fdc00b17bd4ad6f4e25ea7688a39dd315933cb0065a5d3dac311230d52d1f311013a0466276c0747dbdd651709376acc87309ba6d54e77c13'
  }
  
  config.action_controller.session_store = :active_record_store
  
  config.action_mailer.smtp_settings = {
      :tls => true,
      :address => "smtp.gmail.com",
      :port => 587,
      :domain => "handyrailstips.com",
      :authentication => :login,
      :user_name => "handyrailstips@gmail.com",
      :password => "guapaa11bounce"
    }
  
  config.action_view.field_error_proc = lambda {|html_tag, instance_tag| "<span class='field_with_errors'>#{html_tag}</span>"}

end
require "will_paginate"
