# frozen_string_literal: true

module Types
  class AuthorType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :biography, String
    field :born_at, GraphQL::Types::ISO8601Date
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :books, [ Types::BookType ], null: false
  end
end
