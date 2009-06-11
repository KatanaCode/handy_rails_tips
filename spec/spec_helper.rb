ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

#email spec
require "email_spec/helpers"
require "email_spec/matchers"

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  config.mock_with :mocha


  def reset_everything
    [Ad, Comment, Favorite, Feedback, Newsletter, 
      Search, Subscriber, Tip, User].map(&:destroy_all)
  end

end
