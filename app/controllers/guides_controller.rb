class GuidesController < ApplicationController
  
  def index
    guides = Guide.published.not_highlighted
    guides = if params[:sort_by].nil? || params[:sort_by] == 'popularity'
      guides.sort_by_popularity
    else
      guides.sort_by_most_recent
    end
    @guides = guides.paginate(:per_page => 9, :page => params[:page])
  end

  def show
  end

end
