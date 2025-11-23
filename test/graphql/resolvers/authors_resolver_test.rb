require "test_helper"

class Resolvers::AuthorsResolverTest < ActiveSupport::TestCase
  test "returns all authors" do
    query_string = <<~GQL
      query {
        authors {
          id
          name
          biography
          bornAt
        }
      }
    GQL

    result = execute_graphql(query_string)
    assert_nil result["errors"]

    authors_data = result["data"]["authors"]
    assert_equal 3, authors_data.length

    author_names = authors_data.map { |a| a["name"] }.sort
    assert_includes author_names, "J.K. Rowling"
    assert_includes author_names, "George Orwell"
    assert_includes author_names, "Jane Austen"
  end

  test "returns empty array when no authors exist" do
    Author.destroy_all

    query_string = <<~GQL
      query {
        authors {
          id
          name
        }
      }
    GQL

    result = execute_graphql(query_string)
    assert_nil result["errors"]

    authors_data = result["data"]["authors"]
    assert_equal 0, authors_data.length
  end

  test "returns authors with their books" do
    query_string = <<~GQL
      query {
        authors {
          id
          name
          books {
            id
            title
          }
        }
      }
    GQL

    result = execute_graphql(query_string)
    assert_nil result["errors"]

    authors_data = result["data"]["authors"]
    jk_rowling = authors_data.find { |a| a["name"] == "J.K. Rowling" }

    assert jk_rowling.present?
    assert_equal 1, jk_rowling["books"].length
    assert_equal "Harry Potter and the Philosopher's Stone", jk_rowling["books"].first["title"]
  end
end
