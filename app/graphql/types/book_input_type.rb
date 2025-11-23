# frozen_string_literal: true

module Types
  class BookInputType < Types::BaseInputObject
    argument :title, String, required: false
    argument :isbn, String, required: false
    argument :published_at, GraphQL::Types::ISO8601Date, required: false
    argument :author_id, Integer, required: false
  end
end
