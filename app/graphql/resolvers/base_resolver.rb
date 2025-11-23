# frozen_string_literal: true

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    def require_authentication!
      raise GraphQL::ExecutionError, "You must be logged in" unless context[:current_user]
    end

    def current_user
      context[:current_user]
    end
  end
end
