ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    module AuthenticationTestHelper
      def log_in_as(user,password)
        post session_path, params: { email_address: user.email_address, password: password }
      end
    
      def log_out
        delete session_path(:current)
      end
    end
    module AdminAuthenticationTestHelper
      def log_in_as_admin(admin,password)
        post admin_session_path, params: { email_address: admin.email_address, password: password }
      end
    
      def log_out_admin
        delete admin_session_path(:current)
      end
    end
  end
end

class ActionDispatch::IntegrationTest
  include ActiveSupport::TestCase::AuthenticationTestHelper
  include ActiveSupport::TestCase::AdminAuthenticationTestHelper
end