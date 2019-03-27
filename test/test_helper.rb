ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures
  # /*.yml for all tests in alphabetical order.
  fixtures :all
end
