# frozen_string_literal: true

module Resolvers
  class AuthorsResolver < BaseResolver
    type [ Types::AuthorType ], null: false

    def resolve
      require_authentication!

      Author.all
    end
  end
end
