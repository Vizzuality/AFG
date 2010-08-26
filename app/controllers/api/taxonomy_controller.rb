class Api::TaxonomyController < ApplicationController
  
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
    
    
    
    respond_to do |format|
      format.json do 
        render :json => {
          :name => k,
          :id => params[:id],
          :childs => taxonomies.map do |taxonomy|
            {
              :id => taxonomy.id,
              :name => taxonomy.name,
              :count => taxonomy.species_count,
              :add_url => (@current_guide.include_taxonomy?(taxonomy) ? nil : entries_url(:type => taxonomy.hierarchy.humanize, :id => taxonomy.name))
            }
          end
        }.to_json
      end
    end
  end
  
end
