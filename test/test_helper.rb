ENV["RAILS_ENV"] ||= "test"
expand_path("../config/environment", __dir__)
require "rails/test_help"
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests
  # Add more helper methods to be used by all tests here...
end
