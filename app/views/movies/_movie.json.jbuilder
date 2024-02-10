json.extract! movie, :id, :title, :watched_at, :created_at, :updated_at
json.url movie_url(movie, format: :json)
