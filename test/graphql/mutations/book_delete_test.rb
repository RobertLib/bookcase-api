require "test_helper"

class Mutations::BookDeleteTest < ActiveSupport::TestCase
  def setup
    @book = books(:pride_and_prejudice)
  end

  test "deletes an existing book" do
    query_string = <<~GQL
      mutation($input: BookDeleteInput!) {
        bookDelete(input: $input) {
          book {
            id
            title
          }
        }
      }
    GQL

    variables = {
      input: {
        id: @book.id
      }
    }

    assert_difference "Book.count", -1 do
      result = execute_graphql(query_string, variables: variables)
      assert_nil result["errors"]

      book_data = result["data"]["bookDelete"]["book"]
      assert_equal @book.title, book_data["title"]
    end
  end

  test "does not delete author when deleting book" do
    author = @book.author

    query_string = <<~GQL
      mutation($input: BookDeleteInput!) {
        bookDelete(input: $input) {
          book {
            id
          }
        }
      }
    GQL

    variables = {
      input: {
        id: @book.id
      }
    }

    assert_no_difference "Author.count" do
      assert_difference "Book.count", -1 do
        result = execute_graphql(query_string, variables: variables)
        assert_nil result["errors"]
      end
    end

    assert Author.exists?(author.id)
  end

  test "raises error when book not found" do
    query_string = <<~GQL
      mutation($input: BookDeleteInput!) {
        bookDelete(input: $input) {
          book {
            id
          }
        }
      }
    GQL

    variables = {
      input: {
        id: 99999
      }
    }

    assert_raises(ActiveRecord::RecordNotFound) do
      execute_graphql(query_string, variables: variables)
    end
  end
end
