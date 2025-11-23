# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
Book.destroy_all
Author.destroy_all

# Create authors
jk_rowling = Author.create!(
  name: "J.K. Rowling",
  biography: "Joanne Rowling is a British author, best known for writing the Harry Potter fantasy series. She has won multiple awards and is one of the best-selling authors in history.",
  born_at: Date.new(1965, 7, 31)
)

tolkien = Author.create!(
  name: "J.R.R. Tolkien",
  biography: "John Ronald Reuel Tolkien was an English writer, philologist, and university professor, best known as the author of the fantasy works The Hobbit and The Lord of the Rings.",
  born_at: Date.new(1892, 1, 3)
)

orwell = Author.create!(
  name: "George Orwell",
  biography: "George Orwell was an English novelist, essayist, journalist, and critic. His work is characterized by lucid prose, social criticism, opposition to totalitarianism, and support of democratic socialism.",
  born_at: Date.new(1903, 6, 25)
)

kafka = Author.create!(
  name: "Franz Kafka",
  biography: "Franz Kafka was a German-speaking Bohemian novelist and short-story writer, widely regarded as one of the major figures of 20th-century literature. His works combine realism and the fantastic.",
  born_at: Date.new(1883, 7, 3)
)

capek = Author.create!(
  name: "Karel Čapek",
  biography: "Karel Čapek was a Czech writer, playwright, and critic. He is best known for his science fiction works, including the play R.U.R., which introduced the word 'robot'.",
  born_at: Date.new(1890, 1, 9)
)

# Create books
jk_rowling.books.create!([
  {
    title: "Harry Potter and the Philosopher's Stone",
    isbn: "978-0-7475-3269-9",
    published_at: Date.new(1997, 6, 26)
  },
  {
    title: "Harry Potter and the Chamber of Secrets",
    isbn: "978-0-7475-3849-3",
    published_at: Date.new(1998, 7, 2)
  },
  {
    title: "Harry Potter and the Prisoner of Azkaban",
    isbn: "978-0-7475-4215-5",
    published_at: Date.new(1999, 7, 8)
  },
  {
    title: "Harry Potter and the Goblet of Fire",
    isbn: "978-0-7475-4624-5",
    published_at: Date.new(2000, 7, 8)
  }
])

tolkien.books.create!([
  {
    title: "The Hobbit",
    isbn: "978-0-618-00221-3",
    published_at: Date.new(1937, 9, 21)
  },
  {
    title: "The Lord of the Rings: The Fellowship of the Ring",
    isbn: "978-0-618-00222-0",
    published_at: Date.new(1954, 7, 29)
  },
  {
    title: "The Lord of the Rings: The Two Towers",
    isbn: "978-0-618-00223-7",
    published_at: Date.new(1954, 11, 11)
  },
  {
    title: "The Lord of the Rings: The Return of the King",
    isbn: "978-0-618-00224-4",
    published_at: Date.new(1955, 10, 20)
  }
])

orwell.books.create!([
  {
    title: "1984",
    isbn: "978-0-452-28423-4",
    published_at: Date.new(1949, 6, 8)
  },
  {
    title: "Animal Farm",
    isbn: "978-0-452-28424-1",
    published_at: Date.new(1945, 8, 17)
  }
])

kafka.books.create!([
  {
    title: "The Metamorphosis",
    isbn: "978-0-553-21369-8",
    published_at: Date.new(1915, 10, 1)
  },
  {
    title: "The Trial",
    isbn: "978-0-8052-0999-8",
    published_at: Date.new(1925, 4, 26)
  },
  {
    title: "The Castle",
    isbn: "978-0-8052-0997-4",
    published_at: Date.new(1926, 4, 1)
  }
])

capek.books.create!([
  {
    title: "R.U.R.",
    isbn: "978-0-14-118208-2",
    published_at: Date.new(1920, 1, 25)
  },
  {
    title: "War with the Newts",
    isbn: "978-0-8101-0049-0",
    published_at: Date.new(1936, 1, 1)
  },
  {
    title: "Krakatit",
    isbn: "978-0-945774-26-7",
    published_at: Date.new(1924, 1, 1)
  }
])

puts "Seed completed!"
puts "Created #{Author.count} authors and #{Book.count} books."
