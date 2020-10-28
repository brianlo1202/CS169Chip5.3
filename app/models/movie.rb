class Movie < ActiveRecord::Base
  def Movie.all_ratings
    return ['G','PG','PG-13','R']
  end
  
  def Movie.with_ratings(ratings)
    if ratings.empty?
      return self.all 
    else
      return where(rating: ratings)
    end
  end
end
