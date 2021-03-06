class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
        
    @all_ratings = Movie.all_ratings()
        
    # handle check box filter
    if params.has_key?(:ratings)  
      @ratings_to_show = params[:ratings].keys
    else
      @ratings_to_show = []
    
    end
    
    if not params.has_key?(:home)
      puts("CAME FROM DIFF PAGE")
      if session.has_key?(:ratingsToShow)
        @ratings_to_show = session[:ratingsToShow]
      end
    end
    
    session[:ratingsToShow] = @ratings_to_show      
     
          
    @movies = Movie.with_ratings(@ratings_to_show)
    
    # handle sorting
    @movie_title_col_class = "bg-transparent"
    @release_date_col_class = "bg-transparent"
    if params.has_key?(:clickedCol)
      colToSort = params[:clickedCol]
      puts("col to Sort: " + colToSort)
      if colToSort == "Movie Title"
        @movies = @movies.order(:title)
        @movie_title_col_class = "hilite" + " " + "bg-warning"
      elsif colToSort == "Release Date"
        @movies = @movies.order(:release_date)
        @release_date_col_class = "bg-warning hilite"
      end
      
      #cookie
      session[:colToSort] = colToSort
      
     elsif session.has_key?(:colToSort) 
       colToSort = session[:colToSort]
      puts("col to Sort: " + colToSort)
      if colToSort == "Movie Title"
        @movies = @movies.order(:title)
        @movie_title_col_class = "hilite" + " " + "bg-warning"
      elsif colToSort == "Release Date"
        @movies = @movies.order(:release_date)
        @release_date_col_class = "bg-warning hilite"
      end
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
