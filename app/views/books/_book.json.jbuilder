json.extract! book, :id, :title, :quality, :created_at, :updated_at
json.url book_url(book, format: :json)
