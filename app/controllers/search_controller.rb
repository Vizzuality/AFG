class SearchController < ApplicationController
  
  def index
    @guides = Guide.find_by_term(params[:q]).paginate(:per_page => 10, :page => params[:page])
    @species = Species.complete.find_by_term(params[:q]).paginate(:per_page => 10, :page => params[:page])
  end

end
