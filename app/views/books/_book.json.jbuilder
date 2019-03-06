json.extract! book, :id, :title, :title_kana, :author, :format, :price, :publisher, :published, :summary, :created_at, :updated_at
json.url book_url(book, format: :json)
