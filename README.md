# Rails Turbo 8

## Overview
Turbo 8 is a Ruby on Rails feature designed to streamline real-time data transmission, enhancing the dynamic capabilities of Rails applications. Leveraging WebSockets, Turbo 8 facilitates seamless communication between the server and client, enabling automatic updates to the user interface without the need for manual page reloads.

Turbo 8 establishes a persistent connection between the client and server, enabling bidirectional data flow. When changes occur on the server side, Turbo 8 automatically pushes updates to connected clients, ensuring that the user interface reflects the latest application state in real-time.

This broadcasting mechanism significantly improves the responsiveness and interactivity of Rails applications, making them more engaging for users. By eliminating frequent page refreshes, Turbo 8 enhances the user experience and simplifies development, allowing developers to focus on building functionality without manual data synchronization concerns.

## Getting Started
To integrate Turbo 8 into your Rails project, follow these steps:

### 1. Create Project
```bash
rails new watching_movies -T
```

### 2. Add Additional Gems

In file `Gemfile`

```bash
bundle add tailwindcss-rails
rails tailwindcss:install
gem install foreman
bundle add faker
```

- Tailwind CSS into your Rails project.
- Foreman gem, which is used for managing Procfile-based applications.
- Faker gem to your project, which is used for generating fake data for seeding the database.

### 3. Scaffold Movie

```bash
rails g scaffold movie title watched_at:datetime
```

This command generates a scaffold for the Movie model, including a title attribute and a watched_at attribute of type datetime.

### 4. Implement Turbo 8 in Model

In your `app/models/movie.rb`, add the following code to enable Turbo 8 broadcasting:

```ruby
class Movie < ApplicationRecord
  broadcasts_refreshes # update and destroy take care of this
  after_create :broadcast_create
  
  private
  
  def broadcast_create
    broadcast_prepend_to self, target: "movies", partial: "movies/movie", locals: { movie: self } 
  end
end
```

This code sets up broadcasting for the Movie model, ensuring that any newly created movie instances are automatically broadcasted to connected clients.

### 5. Configure Turbo Stream in View

At the top of the `app/views/movies/_movie.html.erb` file, add:

```erb
<%= turbo_stream_from movie %>
```

This line establishes a connection to the Turbo Stream for the individual movie record, ensuring that any updates to the movie instance are automatically reflected in real-time.

In your `app/views/movies/index.html.erb`, include the following code:

```erb
<div id="movies" class="min-w-full">
  <%= turbo_stream_from :movies %>
  <%= render @movies %>
</div>
```

This code sets up **Turbo Stream** for the movies index page. The **turbo_stream_from :movies** line establishes a connection to the **Turbo Stream** for the movies collection, while **<%= render @movies %>** renders the list of movies. Any updates to the movies collection will be automatically reflected in real-time on the page.

### 6. Update Controller

In your `app/controllers/movies_controller.rb`, ensure the index action orders movies appropriately:

```ruby
def index
  @movies = Movie.order(created_at: :desc)
end
```

This code snippet modifies the index action of the movies controller to retrieve movies from the database ordered by their creation time in descending order (**created_at: :desc**). By ensuring that the latest movies appear first in the list, this adjustment enhances the user experience by presenting the most recent content upfront.

### 7. Prepare Database

In your `db/seeds.rb` file, add the following code to populate the database with sample data:

```ruby
10.times do
  Movie.create(title: Faker::Movie.title)
end
```

This code snippet uses the Faker gem to generate 10 fake movie records with random titles. These records are created to populate the database with sample data for testing and development purposes.

Then run the following commands to set up and seed the database:

```bash
rails db:drop db:create db:migrate db:seed
```

These commands ensure the database is dropped and recreated, migrations are applied, and the seed data is inserted into the database. Running these commands prepares your Rails application with the initial data required for testing and development.

### Conclusion

By following the steps outlined above, you've successfully integrated Turbo 8 into your Rails application, enabling automatic broadcasting of data updates and enhancing real-time capabilities. With Turbo 8, your application can now deliver a more dynamic and interactive user experience, keeping users engaged and informed with live updates without the need for manual page refreshes. Happy coding!