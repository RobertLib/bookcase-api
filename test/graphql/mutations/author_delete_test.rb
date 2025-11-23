require "test_helper"

class Mutations::AuthorDeleteTest < ActiveSupport::TestCase
  def setup
    @author = authors(:jane_austen)
  end

  test "deletes an existing author" do
    query_string = <<~GQL
      mutation($input: AuthorDeleteInput!) {
        authorDelete(input: $input) {
          author {
            id
            name
          }
        }
      }
    GQL

    variables = {
      input: {
        id: @author.id
      }
    }

    assert_difference "Author.count", -1 do
      result = execute_graphql(query_string, variables: variables)
      assert_nil result["errors"]

      author_data = result["data"]["authorDelete"]["author"]
      assert_equal @author.name, author_data["name"]
    end
  end

  test "deletes author and its associated books" do
    author_with_books = authors(:jk_rowling)
    book_count = author_with_books.books.count

    query_string = <<~GQL
      mutation($input: AuthorDeleteInput!) {
        authorDelete(input: $input) {
          author {
            id
          }
        }
      }
    GQL

    variables = {
      input: {
        id: author_with_books.id
      }
    }

    assert_difference "Author.count", -1 do
      assert_difference "Book.count", -book_count do
        result = execute_graphql(query_string, variables: variables)
        assert_nil result["errors"]
      end
    end
  end

  test "raises error when author not found" do
    query_string = <<~GQL
      mutation($input: AuthorDeleteInput!) {
        authorDelete(input: $input) {
          author {
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
