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

    
    if params[:ratings].nil?
      flash.keep
      if session[:ratings]
        params[:ratings] = session[:ratings]
      else
        params[:ratings] = @all_ratings
      end
      redirect_to movies_path({ratings: params[:ratings], sort: session[:sort]})
      return
    else
      if session[:ratings] != params[:ratings]
        session[:ratings] = params[:ratings]
      end
        # Set rating check_box_tag  
        @checked_ratings = session[:ratings]
    end
    
    if params[:sort].nil? and not session[:sort].nil?
      flash.keep
      puts "aaa"
      redirect_to movies_path({ratings: session[:ratings], sort: session[:sort]})
      return
    end

    if session[:sort] != params[:sort]
      session[:sort] = params[:sort]
    end
    
    if session[:sort].nil? and session[:ratings]
      @movies = @movies.with_ratings(session[:ratings])
    elsif session[:sort] and session[:ratings].nil?
      @movies = @movies.order(session[:sort])
    elsif session[:sort] and session[:ratings]
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
    return
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
    return
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
    return
  end

end
