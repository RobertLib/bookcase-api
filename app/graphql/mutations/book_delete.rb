# frozen_string_literal: true

module Mutations
  class BookDelete < BaseMutation
    description "Deletes a book by ID"

    field :book, Types::BookType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      require_authentication!

      book = ::Book.find(id)
      raise GraphQL::ExecutionError.new "Error deleting book", extensions: book.errors.to_hash unless book.destroy!

      { book: book }
    end
  end
end
