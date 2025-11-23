# frozen_string_literal: true

module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :isbn, String
    field :published_at, GraphQL::Types::ISO8601Date
    field :author_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :author, Types::AuthorType, null: false
  end
end
