RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.load_paths += %W( #{RAILS_ROOT}/app/observers )
  config.gem 'will_paginate', :lib => 'will_paginate',  :version => '>=2.2.2'
  config.gem "RedCloth",      :lib => false,            :version => ">=4.1.9"
  config.gem "coderay",       :lib => false,            :version => ">=0.8.312"
  config.gem "markaby",                                 :version => ">=0.5"
  config.gem "less",                                    :version => ">=0.8.9"
    
  Dir.chdir("#{Rails.root}/app/observers") do
    config.active_record.observers = Dir.glob("*_observer.rb").collect {|ob_name| ob_name.split(".").first}
  end

  config.time_zone = 'UTC'
  config.action_view.field_error_proc = lambda {|html_tag, instance_tag| "<span class='field_with_errors'>#{html_tag}</span>"}

end