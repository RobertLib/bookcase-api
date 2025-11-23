require "test_helper"

class Mutations::BookUpdateTest < ActiveSupport::TestCase
  def setup
    @book = books(:book_1984)
    @new_author = authors(:jane_austen)
  end

  test "updates an existing book with valid attributes" do
    query_string = <<~GQL
      mutation($input: BookUpdateInput!) {
        bookUpdate(input: $input) {
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
        id: @book.id,
        bookInput: {
          title: "Nineteen Eighty-Four",
          isbn: "978-0451524935-UPDATED",
          authorId: @book.author.id
        }
      }
    }

    result = execute_graphql(query_string, variables: variables)
    assert_nil result["errors"]

    book_data = result["data"]["bookUpdate"]["book"]
    assert_equal "Nineteen Eighty-Four", book_data["title"]
    assert_equal "978-0451524935-UPDATED", book_data["isbn"]

    @book.reload
    assert_equal "Nineteen Eighty-Four", @book.title
  end

  test "updates book author" do
    query_string = <<~GQL
      mutation($input: BookUpdateInput!) {
        bookUpdate(input: $input) {
          book {
            id
            title
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
        id: @book.id,
        bookInput: {
          title: @book.title,
          authorId: @new_author.id
        }
      }
    }

    result = execute_graphql(query_string, variables: variables)
    assert_nil result["errors"]

    book_data = result["data"]["bookUpdate"]["book"]
    assert_equal @new_author.name, book_data["author"]["name"]

    @book.reload
    assert_equal @new_author.id, @book.author_id
  end

  test "returns error when updating with blank title" do
    query_string = <<~GQL
      mutation($input: BookUpdateInput!) {
        bookUpdate(input: $input) {
          book {
            id
            title
          }
        }
      }
    GQL

    variables = {
      input: {
        id: @book.id,
        bookInput: {
          title: "",
          authorId: @book.author.id
        }
      }
    }

    result = execute_graphql(query_string, variables: variables)
    assert result["errors"].present?
    assert_includes result["errors"][0]["message"], "Error updating book"
  end

  test "raises error when book not found" do
    query_string = <<~GQL
      mutation($input: BookUpdateInput!) {
        bookUpdate(input: $input) {
          book {
            id
            title
          }
        }
      }
    GQL

    variables = {
      input: {
        id: 99999,
        bookInput: {
          title: "New Title",
          authorId: @book.author.id
        }
      }
    }

    assert_raises(ActiveRecord::RecordNotFound) do
      execute_graphql(query_string, variables: variables)
    end
  end
end
