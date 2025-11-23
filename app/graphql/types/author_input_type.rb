# frozen_string_literal: true

module Types
  class AuthorInputType < Types::BaseInputObject
    argument :name, String, required: false
    argument :biography, String, required: false
    argument :born_at, GraphQL::Types::ISO8601Date, required: false
  end
end
