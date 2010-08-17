class SpeciesController < ApplicationController
  
  DEFAULT_PARAMS = ['action', 'controller', 'taxonomy', 'page']
  AVAILABLE_PARAMS = ['kingdom', 'phylum', 't_class', 'order', 'family', 'genus']
  
  def index
    if params[:taxonomy].blank?
      @featured_species = Species.featured.first
      @species = Species.complete.not_featured.limit(6).order("guides_count DESC")
      render :action => 'index'
    else
      species = if (params.keys - DEFAULT_PARAMS - AVAILABLE_PARAMS).size > 0
        raise "Invalid parameter(s): #{(params.keys - DEFAULT_PARAMS - AVAILABLE_PARAMS).join(',')}"
      elsif (params.keys & AVAILABLE_PARAMS).size == 0
        raise "Empty parameters"
      elsif (params.keys & AVAILABLE_PARAMS).size == 1 && params[:kingdom]
        @taxonomy = "kingdom"
        @term = params[:kingdom]
        Species.complete.where(:kingdom => params[:kingdom])
      elsif (params.keys & AVAILABLE_PARAMS).size == 2 && params[:kingdom] && params[:phylum]
        @taxonomy = "phylum"
        @term = params[:phylum]
        Species.complete.where(:kingdom => params[:kingdom], :phylum => params[:phylum])
      elsif (params.keys & AVAILABLE_PARAMS).size == 3 && params[:kingdom] && params[:phylum] && params[:t_class]
        @taxonomy = "class"
        @term = params[:t_class]
        Species.complete.where(:kingdom => params[:kingdom], :phylum => params[:phylum], :t_class => params[:t_class])
      elsif (params.keys & AVAILABLE_PARAMS).size == 4 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:order]
        @taxonomy = "order"
        @term = params[:order]
        Species.complete.where(:kingdom => params[:kingdom], :phylum => params[:phylum], :t_class => params[:t_class], :t_order => params[:order])
      elsif (params.keys & AVAILABLE_PARAMS).size == 5 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:order] && params[:family]
        @taxonomy = "family"
        @term = params[:family]
        Species.complete.where(:kingdom => params[:kingdom], :phylum => params[:phylum], :t_class => params[:t_class], :t_order => params[:order], :family => params[:family])
      elsif (params.keys & AVAILABLE_PARAMS).size == 6 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:order] && params[:family] && params[:genus]
        @taxonomy = "genus"
        @term = params[:genus]
        Species.complete.where(:kingdom => params[:kingdom], :phylum => params[:phylum], :t_class => params[:t_class], :t_order => params[:order], :family => params[:family], :genus => params[:genus])
      end
      @species = species.order("species DESC").paginate :page => params[:page], :per_page => 12
      raise "Invalid values" if @species.total_entries == 0
      render :action => 'taxonomy'
    end
  end
  
  def show
    @species = Species.complete.find(params[:id])
  end
  
end
