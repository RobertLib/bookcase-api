# frozen_string_literal: true

module Mutations
  class AuthorDelete < BaseMutation
    description "Deletes a author by ID"

    field :author, Types::AuthorType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      require_authentication!

      author = ::Author.find(id)
      raise GraphQL::ExecutionError.new "Error deleting author", extensions: author.errors.to_hash unless author.destroy!

      { author: author }
    end
  end
end
