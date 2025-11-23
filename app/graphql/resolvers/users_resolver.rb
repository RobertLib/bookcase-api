# frozen_string_literal: true

module Resolvers
  class UsersResolver < BaseResolver
    type [ Types::UserType ], null: false

    def resolve
      require_authentication!

      User.all
    end
  end
end
