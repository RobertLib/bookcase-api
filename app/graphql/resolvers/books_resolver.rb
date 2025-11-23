# frozen_string_literal: true

module Resolvers
  class BooksResolver < BaseResolver
    type [ Types::BookType ], null: false

    def resolve
      require_authentication!

      Book.all
    end
  end
end
