# frozen_string_literal: true

module Mutations
  class BookUpdate < BaseMutation
    description "Updates a book by id"

    field :book, Types::BookType, null: false

    argument :id, ID, required: true
    argument :book_input, Types::BookInputType, required: true

    def resolve(id:, book_input:)
      require_authentication!

      book = ::Book.find(id)
      raise GraphQL::ExecutionError.new "Error updating book", extensions: book.errors.to_hash unless book.update(**book_input)

      { book: book }
    end
  end
end
