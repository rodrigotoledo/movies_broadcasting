class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.datetime :watched_at

      t.timestamps
    end
  end
end
