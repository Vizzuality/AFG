class TaxonomyController < ApplicationController
  
  DEFAULT_PARAMS = ['action', 'controller', 'format']
  AVAILABLE_PARAMS = ['kingdom', 'phylum', 't_class', 'order', 'family', 'genus']
  
  def index
    response = if (params.keys - DEFAULT_PARAMS - AVAILABLE_PARAMS).size > 0
      "Invalida parameter(s): #{(params.keys - DEFAULT_PARAMS - AVAILABLE_PARAMS).join(',')}"
    elsif (params.keys & AVAILABLE_PARAMS).size == 0
      Taxonomy.kingdoms.to_json
    elsif (params.keys & AVAILABLE_PARAMS).size == 1 && params[:kingdom]
      Taxonomy.phylums(params[:kingdom])
    elsif (params.keys & AVAILABLE_PARAMS).size == 2 && params[:kingdom] && params[:phylum]
      Taxonomy.t_classes(params[:kingdom], params[:phylum])
    elsif (params.keys & AVAILABLE_PARAMS).size == 3 && params[:kingdom] && params[:phylum] && params[:t_class]
      Taxonomy.t_orders(params[:kingdom], params[:phylum], params[:t_class])
    elsif (params.keys & AVAILABLE_PARAMS).size == 4 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:order]
      Taxonomy.families(params[:kingdom], params[:phylum], params[:t_class], params[:order])
    elsif (params.keys & AVAILABLE_PARAMS).size == 5 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:order] && params[:family]
      Taxonomy.genus(params[:kingdom], params[:phylum], params[:t_class], params[:order], params[:family])
    elsif (params.keys & AVAILABLE_PARAMS).size == 6 && params[:kingdom] && params[:phylum] && params[:t_class] && params[:order] && params[:family] && params[:genus]
      Taxonomy.species(params[:kingdom], params[:phylum], params[:t_class], params[:order], params[:family], params[:genus])
    end
    respond_to do |format|
      format.json { render :json => response }
    end
  end
  
end
