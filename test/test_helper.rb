ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def login_as(user, password: "password")
      post session_url, params: { email: user.email, password: password }
      return if cookies[:session_id]

      raise "Could not sign in user with email: #{user.email} and password: #{password}" unless cookies[:session_id]
    end

    def log_out
      delete session_url
    end
  end
end
