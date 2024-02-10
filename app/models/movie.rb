class Movie < ApplicationRecord
  broadcasts_refreshes
  after_create :broadcast_create
  private

  def broadcast_create
    broadcast_prepend_to self, target: "movies", partial: "movies/movie", locals: { movie: self } 
  end
end
