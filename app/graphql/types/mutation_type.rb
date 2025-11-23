# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :book_delete, mutation: Mutations::BookDelete
    field :book_update, mutation: Mutations::BookUpdate
    field :book_create, mutation: Mutations::BookCreate
    field :author_delete, mutation: Mutations::AuthorDelete
    field :author_update, mutation: Mutations::AuthorUpdate
    field :author_create, mutation: Mutations::AuthorCreate
  end
end
