require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    book = Book.new(
      title: "The Great Gatsby",
      isbn: "978-0743273565",
      published_at: "1925-04-10",
      author: authors(:george_orwell)
    )
    assert book.valid?
  end

  test "should not be valid without a title" do
    book = Book.new(author: authors(:george_orwell))
    assert_not book.valid?
    assert_includes book.errors[:title], "can't be blank"
  end

  test "should not be valid without an author" do
    book = Book.new(title: "A Book Without Author")
    assert_not book.valid?
    assert_includes book.errors[:author], "must exist"
  end

  test "should belong to an author" do
    book = books(:harry_potter)
    assert_respond_to book, :author
    assert_equal authors(:jk_rowling), book.author
  end

  test "should have optional isbn and published_at" do
    book = Book.new(title: "Valid Book", author: authors(:jane_austen))
    assert book.valid?
  end
end
