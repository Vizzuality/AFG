class SearchController < ApplicationController
  
  def index
    if params[:q].blank?
      @results = []
    else
      results = []
      @total_guides     = Guide.find_by_term(params[:q])
      @total_species    = Species.complete.find_by_term(params[:q])
      @total_landscapes = Landscape.find_by_term(params[:q])
      if params[:type]
        results = case params[:type]
          when 'species'
            @total_species
          when 'guides'
            @total_guides
          when 'landscapes'
            @total_landscapes
        end
      else
        results = (@total_guides + @total_species + @total_landscapes).sort{ |b,a| a.send(a.sort_by_attribute) <=> b.send(b.sort_by_attribute)}
      end
      current_page = params[:page].blank? ? 1 : params[:page].to_i
      @results = WillPaginate::Collection.create(current_page, 8, results.size) do |pager| 
        pager.replace(results.slice(pager.per_page * (pager.current_page-1), pager.per_page))
      end
    end
  end

end
