# frozen_string_literal: true

module Mutations
  class BookCreate < BaseMutation
    description "Creates a new book"

    field :book, Types::BookType, null: false

    argument :book_input, Types::BookInputType, required: true

    def resolve(book_input:)
      require_authentication!

      book = ::Book.new(**book_input)
      raise GraphQL::ExecutionError.new "Error creating book", extensions: book.errors.to_hash unless book.save

      { book: book }
    end
  end
end
