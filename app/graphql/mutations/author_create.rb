# frozen_string_literal: true

module Mutations
  class AuthorCreate < BaseMutation
    description "Creates a new author"

    field :author, Types::AuthorType, null: false

    argument :author_input, Types::AuthorInputType, required: true

    def resolve(author_input:)
      require_authentication!

      author = ::Author.new(**author_input)
      raise GraphQL::ExecutionError.new "Error creating author", extensions: author.errors.to_hash unless author.save

      { author: author }
    end
  end
end
