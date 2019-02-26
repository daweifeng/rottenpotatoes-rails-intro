class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @movies = Movie.all
    @all_ratings = @movies.getRatings

    if session[:ratings] != params[:ratings]
      session[:ratings] = params[:ratings]
    end

    # Set rating check_box_tag 
    if session[:ratings].nil?
      @checked_ratings = []
    else
      @checked_ratings = session[:ratings]
    end
    
    
    if session[:sort] != params[:sort]
      session[:sort] = params[:sort]
    end
    
    if session[:sort].nil? and session[:ratings]
      puts session[:ratings]

      @movies = @movies.with_ratings(session[:ratings])
    elsif session[:sort] and session[:ratings].nil?
      puts session[:sort]
      @movies = @movies.order(session[:sort])
    elsif session[:sort] and session[:ratings]
      puts session[:ratings]
      puts session[:sort]
      @movies = @movies.order(params[:sort]).select {|movie| params[:ratings].include? movie.rating}
    else
      @movies = Movie.all
    end


    # if params[:sort]
    #   @movies = @movies.order(params[:sort])
    # end
    if params[:sort] == 'title'
      @hilite_title = 'hilite'
    elsif params[:sort] == 'release_date'
      @hilite_release = 'hilite'
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

end
