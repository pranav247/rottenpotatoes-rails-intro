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
    
    # Part 3
    session[:ratings] = params[:ratings] if params[:ratings].key?
    session[:sort_by] = params[:sort_by] if params[:sort_by].key?
       
    
    
    # Part 1
    # @movies = Movie.all.order(params[:sort_by])
    
    @list_all_ratings = Movie.retrieve_ratings
    
    # Part 2
    # @all_ratings = params[:ratings] ? params[:ratings].keys : Movie.retrieve_ratings
    # @movies      = Movie.where(rating: @all_ratings).order(params[:sort_by])

    # Part 3
    @all_ratings = session[:ratings] ? session[:ratings].keys : Movie.retrieve_ratings
    @movies      = Movie.where(rating: @all_ratings).order(session[:sort_by])




    @title_header = 'hilite' if session[:sort_by] == "title"
    @release_date_header = 'hilite' if session[:sort_by] == 'release_date'

    # Part 3 - If session changes, redirecting the page by calling the movies_path
    unless session[:sort_by] == params[:sort_by] && session[:ratings] == params[:ratings]
      flash.keep
      redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
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
