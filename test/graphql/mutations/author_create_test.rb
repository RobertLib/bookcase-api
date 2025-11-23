require "test_helper"

class Mutations::AuthorCreateTest < ActiveSupport::TestCase
  test "creates a new author with valid attributes" do
    query_string = <<~GQL
      mutation($input: AuthorCreateInput!) {
        authorCreate(input: $input) {
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
        authorInput: {
          name: "F. Scott Fitzgerald",
          biography: "American novelist of the Jazz Age",
          bornAt: "1896-09-24"
        }
      }
    }

    assert_difference "Author.count", 1 do
      result = execute_graphql(query_string, variables: variables)
      assert_nil result["errors"]

      author_data = result["data"]["authorCreate"]["author"]
      assert_equal "F. Scott Fitzgerald", author_data["name"]
      assert_equal "American novelist of the Jazz Age", author_data["biography"]
    end
  end

  test "returns error when name is missing" do
    query_string = <<~GQL
      mutation($input: AuthorCreateInput!) {
        authorCreate(input: $input) {
          author {
            id
            name
          }
        }
      }
    GQL

    variables = {
      input: {
        authorInput: {
          biography: "A mysterious author"
        }
      }
    }

    assert_no_difference "Author.count" do
      result = execute_graphql(query_string, variables: variables)
      assert result["errors"].present?
      assert_includes result["errors"][0]["message"], "Error creating author"
    end
  end

  test "creates author with minimal attributes" do
    query_string = <<~GQL
      mutation($input: AuthorCreateInput!) {
        authorCreate(input: $input) {
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
        authorInput: {
          name: "Minimal Author"
        }
      }
    }

    assert_difference "Author.count", 1 do
      result = execute_graphql(query_string, variables: variables)
      assert_nil result["errors"]

      author_data = result["data"]["authorCreate"]["author"]
      assert_equal "Minimal Author", author_data["name"]
      assert_nil author_data["biography"]
      assert_nil author_data["bornAt"]
    end
  end
end
