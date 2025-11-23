# frozen_string_literal: true

module Mutations
  class AuthorUpdate < BaseMutation
    description "Updates a author by id"

    field :author, Types::AuthorType, null: false

    argument :id, ID, required: true
    argument :author_input, Types::AuthorInputType, required: true

    def resolve(id:, author_input:)
      require_authentication!

      author = ::Author.find(id)
      raise GraphQL::ExecutionError.new "Error updating author", extensions: author.errors.to_hash unless author.update(**author_input)

      { author: author }
    end
  end
end
