require "test_helper"

class Mutations::AuthorUpdateTest < ActiveSupport::TestCase
  def setup
    @author = authors(:george_orwell)
  end

  test "updates an existing author with valid attributes" do
    query_string = <<~GQL
      mutation($input: AuthorUpdateInput!) {
        authorUpdate(input: $input) {
          author {
            id
            name
            biography
            bornAt
          }
        }
      }
    GQL

    variables = {
      input: {
        id: @author.id,
        authorInput: {
          name: "George Orwell (Eric Blair)",
          biography: "Updated biography"
        }
      }
    }

    result = execute_graphql(query_string, variables: variables)
    assert_nil result["errors"]

    author_data = result["data"]["authorUpdate"]["author"]
    assert_equal "George Orwell (Eric Blair)", author_data["name"]
    assert_equal "Updated biography", author_data["biography"]

    @author.reload
    assert_equal "George Orwell (Eric Blair)", @author.name
  end

  test "returns error when updating with blank name" do
    query_string = <<~GQL
      mutation($input: AuthorUpdateInput!) {
        authorUpdate(input: $input) {
          author {
            id
            name
          }
        }
      }
    GQL

    variables = {
      input: {
        id: @author.id,
        authorInput: {
          name: ""
        }
      }
    }

    result = execute_graphql(query_string, variables: variables)
    assert result["errors"].present?
    assert_includes result["errors"][0]["message"], "Error updating author"
  end

  test "raises error when author not found" do
    query_string = <<~GQL
      mutation($input: AuthorUpdateInput!) {
        authorUpdate(input: $input) {
          author {
            id
            name
          }
        }
      }
    GQL

    variables = {
      input: {
        id: 99999,
        authorInput: {
          name: "New Name"
        }
      }
    }

    assert_raises(ActiveRecord::RecordNotFound) do
      execute_graphql(query_string, variables: variables)
    end
  end
end
