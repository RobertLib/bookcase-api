require "test_helper"

class Mutations::BookCreateTest < ActiveSupport::TestCase
  def setup
    @author = authors(:george_orwell)
  end

  test "creates a new book with valid attributes" do
    query_string = <<~GQL
      mutation($input: BookCreateInput!) {
        bookCreate(input: $input) {
          book {
            id
            title
            isbn
            publishedAt
            author {
              id
              name
            }
          }
        }
      }
    GQL

    variables = {
      input: {
        bookInput: {
          title: "Animal Farm",
          isbn: "978-0451526342",
          publishedAt: "1945-08-17",
          authorId: @author.id
        }
      }
    }

    assert_difference "Book.count", 1 do
      result = execute_graphql(query_string, variables: variables)
      assert_nil result["errors"]

      book_data = result["data"]["bookCreate"]["book"]
      assert_equal "Animal Farm", book_data["title"]
      assert_equal "978-0451526342", book_data["isbn"]
      assert_equal @author.name, book_data["author"]["name"]
    end
  end

  test "returns error when title is missing" do
    query_string = <<~GQL
      mutation($input: BookCreateInput!) {
        bookCreate(input: $input) {
          book {
            id
            title
          }
        }
      }
    GQL

    variables = {
      input: {
        bookInput: {
          isbn: "123456",
          authorId: @author.id
        }
      }
    }

    assert_no_difference "Book.count" do
      result = execute_graphql(query_string, variables: variables)
      assert result["errors"].present?
      assert_includes result["errors"][0]["message"], "Error creating book"
    end
  end

  test "returns error when author does not exist" do
    query_string = <<~GQL
      mutation($input: BookCreateInput!) {
        bookCreate(input: $input) {
          book {
            id
            title
          }
        }
      }
    GQL

    variables = {
      input: {
        bookInput: {
          title: "Orphan Book",
          authorId: 99999
        }
      }
    }

    assert_no_difference "Book.count" do
      result = execute_graphql(query_string, variables: variables)
      assert result["errors"].present?
    end
  end

  test "creates book with minimal attributes" do
    query_string = <<~GQL
      mutation($input: BookCreateInput!) {
        bookCreate(input: $input) {
          book {
            id
            title
            isbn
            publishedAt
          }
        }
      }
    GQL

    variables = {
      input: {
        bookInput: {
          title: "Minimal Book",
          authorId: @author.id
        }
      }
    }

    assert_difference "Book.count", 1 do
      result = execute_graphql(query_string, variables: variables)
      assert_nil result["errors"]

      book_data = result["data"]["bookCreate"]["book"]
      assert_equal "Minimal Book", book_data["title"]
      assert_nil book_data["isbn"]
      assert_nil book_data["publishedAt"]
    end
  end
end
