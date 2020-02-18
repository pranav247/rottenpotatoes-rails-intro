class Movie < ActiveRecord::Base
  
  def self.retrieve_ratings
    Movie.select(:rating).uniq.map { |each_movie| each_movie.rating }.sort
  end

end
