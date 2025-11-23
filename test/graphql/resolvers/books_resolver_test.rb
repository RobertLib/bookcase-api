require "test_helper"

class Resolvers::BooksResolverTest < ActiveSupport::TestCase
  test "returns all books" do
    query_string = <<~GQL
      query {
        books {
          id
          title
          isbn
          publishedAt
        }
      }
    GQL

    result = execute_graphql(query_string)
    assert_nil result["errors"]

    books_data = result["data"]["books"]
    assert_equal 3, books_data.length

    book_titles = books_data.map { |b| b["title"] }.sort
    assert_includes book_titles, "Harry Potter and the Philosopher's Stone"
    assert_includes book_titles, "1984"
    assert_includes book_titles, "Pride and Prejudice"
  end

  test "returns empty array when no books exist" do
    Book.destroy_all

    query_string = <<~GQL
      query {
        books {
          id
          title
        }
      }
    GQL

    result = execute_graphql(query_string)
    assert_nil result["errors"]

    books_data = result["data"]["books"]
    assert_equal 0, books_data.length
  end

  test "returns books with their authors" do
    query_string = <<~GQL
      query {
        books {
          id
          title
          author {
            id
            name
          }
        }
      }
    GQL

    result = execute_graphql(query_string)
    assert_nil result["errors"]

    books_data = result["data"]["books"]
    harry_potter = books_data.find { |b| b["title"] == "Harry Potter and the Philosopher's Stone" }

    assert harry_potter.present?
    assert_equal "J.K. Rowling", harry_potter["author"]["name"]
  end

  test "returns books with all fields" do
    query_string = <<~GQL
      query {
        books {
          id
          title
          isbn
          publishedAt
          createdAt
          updatedAt
          author {
            id
            name
            biography
            bornAt
          }
        }
      }
    GQL

    result = execute_graphql(query_string)
    assert_nil result["errors"]

    books_data = result["data"]["books"]
    assert books_data.all? { |book| book["id"].present? }
    assert books_data.all? { |book| book["title"].present? }
    assert books_data.all? { |book| book["author"].present? }
  end
end
