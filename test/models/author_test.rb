require "test_helper"

class AuthorTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    author = Author.new(name: "Ernest Hemingway", biography: "American novelist", born_at: "1899-07-21")
    assert author.valid?
  end

  test "should not be valid without a name" do
    author = Author.new(biography: "A great author")
    assert_not author.valid?
    assert_includes author.errors[:name], "can't be blank"
  end

  test "should have many books" do
    author = authors(:jk_rowling)
    assert_respond_to author, :books
  end

  test "should destroy dependent books when author is destroyed" do
    author = authors(:jk_rowling)
    book_id = author.books.first.id

    assert_difference "Book.count", -1 do
      author.destroy
    end

    assert_nil Book.find_by(id: book_id)
  end

  test "should return books for an author" do
    author = authors(:jk_rowling)
    assert_equal 1, author.books.count
    assert_includes author.books, books(:harry_potter)
  end
end
