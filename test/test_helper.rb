ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def login_as(user, on:)
      raise "keyword on: must be a Platform" unless on.is_a?(Platform)
      Current.session = user.sessions.create!(platform: on)

      ActionDispatch::TestRequest.create.cookie_jar.tap do |cookie_jar|
        cookie_jar.signed[:session_id] = Current.session.id
        cookies[:session_id] = cookie_jar[:session_id]
      end
    end

    def log_out
      Current.session&.destroy!
      cookies.delete(:session_id)
    end
  end
end
