require 'pry'
class MoviesController < ApplicationController

  def index
    # queries = []
    # queries << [:title, params[:title]] unless params[:title].blank?
    # queries << [:director, params[:director]] unless params[:director].blank?
    # queries << [:runtime, params[:runtime]] unless params[:runtime].blank?
    # [[:title, "Mad Max"], [:runtime, "0"]]
    # binding.pry
    if params[:runtime_in_minutes].nil?
      @movies = Movie.all
    else
    
#     if params[:title].present?
#       @movies= @movies.search_by_title(params[:title])
#     end

#     if !params[:director].present?
#       @movies= @movies.search_by_director(params[:director])
#     end

    # if !params[:search_term].present?
    #   @movies = @movies.search_term(params[:search_term])
    # end

      @movies = Movie.search_results(params[:search_term]).runtime_in_minutes(params[:runtime_in_minutes])
    end
    # @movies = @movies.runtime(params[:search_term])
# binding.pry
    # @movies = @movies.search(params[:search] ||= "", params[:runtime] ||="")

  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :image, :description
    )
  end

end