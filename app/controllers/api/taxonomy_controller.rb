class Api::TaxonomyController < ApplicationController
  
  DEFAULT_PARAMS = ['action', 'controller', 'format']
  AVAILABLE_PARAMS = ['kingdom', 'phylum', 't_class', 'order', 'family', 'genus']
  
  def index
    taxonomies = if params[:id]
      taxonomy = Taxonomy.find(params[:id])
      case taxonomy.hierarchy
        when 'kingdom'
          k  = 'phylums'
          Taxonomy.phylums(taxonomy.name)
        when 'phylum'
          k = 'classes'
          Taxonomy.t_classes(taxonomy.name)
        when 'class'
          k = 'orders'
          Taxonomy.t_orders(taxonomy.name)
        when 'order'
          k = 'families'
          Taxonomy.families(taxonomy.name)
        when 'family'
          k = 'genus'
          Taxonomy.genus(taxonomy.name)
      end
    else
      k = 'kingdoms'
      Taxonomy.kingdoms
    end
    
    
    # list = if (params.keys - DEFAULT_PARAMS - AVAILABLE_PARAMS).size > 0
    #   "Invalid parameter(s): #{(params.keys - DEFAULT_PARAMS - AVAILABLE_PARAMS).join(',')}"
    # elsif (params.keys & AVAILABLE_PARAMS).size == 0
    #   
    # elsif (params.keys & AVAILABLE_PARAMS).size == 1 && params[:kingdom]
    #   Taxonomy.phylums(params[:kingdom])
    # elsif (params.keys & AVAILABLE_PARAMS).size == 2 && params[:kingdom] && params[:phylum]
    #   Taxonomy.t_classes(params[:kingdom], params[:phylum])
    # elsif (params.keys & AVAILABLE_PARAMS).size == 3 && params[:kingdom] && params[:phylum] && params[:t_class]
    #   Taxonomy.t_orders(params[:kingdom], params[:phylum], params[:t_class])
    # elsif (params.keys & AVAILABLE_PARAMS).size == 4 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:order]
    #   Taxonomy.families(params[:kingdom], params[:phylum], params[:t_class], params[:order])
    # elsif (params.keys & AVAILABLE_PARAMS).size == 5 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:order] && params[:family]
    #   Taxonomy.genus(params[:kingdom], params[:phylum], params[:t_class], params[:order], params[:family])
    # elsif (params.keys & AVAILABLE_PARAMS).size == 6 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:order] && params[:family] && params[:genus]
    #   Taxonomy.species(params[:kingdom], params[:phylum], params[:t_class], params[:order], params[:family], params[:genus])
    # end

    resp = {
      k.to_sym => taxonomies.map do |taxonomy|
        {
          :id => taxonomy.id,
          :name => taxonomy.name,
          :count => taxonomy.species_count,
          :add_url => (@current_guide.include_taxonomy?(taxonomy) ? nil : entries_url(:type => taxonomy.hierarchy.humanize, :id => taxonomy.name))
        }
      end
    }
    
    respond_to do |format|
      format.json do 
        render :json => resp.to_json
      end
    end
  end
  
end
