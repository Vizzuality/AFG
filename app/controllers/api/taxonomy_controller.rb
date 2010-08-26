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
        when 'genus'
          k = 'species'
          Species.complete.where(:genus => taxonomy.name)
      end
    else
      k = 'kingdoms'
      Taxonomy.kingdoms
    end
    
    respond_to do |format|
      format.json do 
        if !taxonomies.nil?
          if k != 'species'
            childs = taxonomies.map do |taxonomy|
              {
                :id => taxonomy.id,
                :name => taxonomy.name,
                :count => taxonomy.species_count,
                :add_url => (@current_guide.include_taxonomy?(taxonomy) ? nil : entries_url(:type => taxonomy.hierarchy.humanize, :id => taxonomy.name)),
                :picture => nil,
                :common_name => nil
              }
            end
          else
            childs = taxonomies.map do |species|
              {
                :id => species.id,
                :name => species.full_name,
                :common_name => species.common_name,
                :count => 0,
                :add_url => (@current_guide.include_species?(species) ? nil : entries_url(:type => 'Species', :id => species.id)),
                :picture => species.picture ? species.picture.image.url(:small) : species.default_picture(:small)
              }
            end
          end
        else
          childs=nil
        end        
        
        render :json => {
          :rank => k,
          :name => taxonomy.name,
          :id => params[:id],
          :childs => childs
        }.to_json
      end
    end
  end
  
end
