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
    def execute_graphql(query_string, variables: {}, context: {})
      default_context = { current_user: users(:one) }
      BookcaseApiSchema.execute(query_string, variables: variables, context: default_context.merge(context))
    end
  end
end
