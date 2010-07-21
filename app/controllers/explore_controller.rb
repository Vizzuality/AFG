class ExploreController < ApplicationController

  def index
    @guides = Guide.published.sort_by_popularity.limit(4)
  end

end
