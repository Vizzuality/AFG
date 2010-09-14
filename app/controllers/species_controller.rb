class SpeciesController < ApplicationController
  
  before_filter :validate_id_param, :only => [:show]
  
  DEFAULT_PARAMS = ['action', 'controller', 'taxonomy', 'page']
  AVAILABLE_PARAMS = ['kingdom', 'phylum', 't_class', 't_order', 'family', 'genus']
  
  def index
    if params[:taxonomy].blank?
      @featured_species = Species.complete.featured.first
      @species = Species.complete.not_featured.limit(6).order("guides_count DESC")
      @species_to_add = 0;
      Taxonomy.kingdoms.each do |taxonomy|
        @species_to_add += taxonomy.species_count
      end
      render :action => 'index'
    else
      species = if (params.keys - DEFAULT_PARAMS - AVAILABLE_PARAMS).size > 0
        raise "Invalid parameter(s): #{(params.keys - DEFAULT_PARAMS - AVAILABLE_PARAMS).join(',')}"
      elsif (params.keys & AVAILABLE_PARAMS).size == 0
        raise "Empty parameters"
      elsif (params.keys & AVAILABLE_PARAMS).size == 1 && params[:kingdom]
        @breadcrumb = [:kingdom]
        @taxonomy = Taxonomy.find_by_hierarchy_and_name('kingdom', params[:kingdom])
        Species.complete.where(:kingdom => params[:kingdom])
      elsif (params.keys & AVAILABLE_PARAMS).size == 2 && params[:kingdom] && params[:phylum]
        @breadcrumb = [:kingdom, :phylum]
        @taxonomy = Taxonomy.find_by_hierarchy_and_name('phylum', params[:phylum])
        Species.complete.where(:kingdom => params[:kingdom], :phylum => params[:phylum])
      elsif (params.keys & AVAILABLE_PARAMS).size == 3 && params[:kingdom] && params[:phylum] && params[:t_class]
        @breadcrumb = [:kingdom, :phylum, :t_class]
        @taxonomy = Taxonomy.find_by_hierarchy_and_name('class', params[:t_class])
        Species.complete.where(:kingdom => params[:kingdom], :phylum => params[:phylum], :t_class => params[:t_class])
      elsif (params.keys & AVAILABLE_PARAMS).size == 4 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:t_order]
        @breadcrumb = [:kingdom, :phylum, :t_class, :t_order]
        @taxonomy = Taxonomy.find_by_hierarchy_and_name('order', params[:t_order])
        Species.complete.where(:kingdom => params[:kingdom], :phylum => params[:phylum], :t_class => params[:t_class], :t_order => params[:t_order])
      elsif (params.keys & AVAILABLE_PARAMS).size == 5 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:t_order] && params[:family]
        @breadcrumb = [:kingdom, :phylum, :t_class, :t_order, :family]
        @taxonomy = Taxonomy.find_by_hierarchy_and_name('family', params[:family])
        Species.complete.where(:kingdom => params[:kingdom], :phylum => params[:phylum], :t_class => params[:t_class], :t_order => params[:t_order], :family => params[:family])
      elsif (params.keys & AVAILABLE_PARAMS).size == 6 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:t_order] && params[:family] && params[:genus]
        @breadcrumb = [:kingdom, :phylum, :t_class, :t_order, :family, :genus]
        @taxonomy = Taxonomy.find_by_hierarchy_and_name('genus', params[:genus])
        Species.complete.where(:kingdom => params[:kingdom], :phylum => params[:phylum], :t_class => params[:t_class], :t_order => params[:t_order], :family => params[:family], :genus => params[:genus])
      end
      @speciesInTaxonomy = species.order("species DESC").paginate :page => params[:page], :per_page => 12
      raise "Invalid values" if @speciesInTaxonomy.total_entries == 0
      render :action => 'taxonomy'
    end
  end
  
  def show
    @species = Species.complete.find(params[:id])
    validate_permalink(@species)
  end
  
end
