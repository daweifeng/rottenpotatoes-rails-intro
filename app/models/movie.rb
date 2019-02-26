class Movie < ActiveRecord::Base
  def self.getRatings
    return Movie.uniq.pluck(:rating)
  end
  def self.with_ratings(ratings)
    return Movie.select {|movie| ratings.include? movie.rating}
  end
end
