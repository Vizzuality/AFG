class Admin::TaxonomiesController < ApplicationController
  
  layout 'admin'
  
  before_filter :admin_authenticated
  
  def index    
    @taxonomies = if params[:q]
      Taxonomy.find_by_term(params[:q])
    else
      Taxonomy
    end
    @taxonomies = @taxonomies.paginate(:per_page => 20, :page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def new
    @taxonomy = Taxonomy.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @taxonomy = Taxonomy.find(params[:id])
  end

  def create
    @taxonomy = Taxonomy.new(params[:taxonomy])

    respond_to do |format|
      if @taxonomy.save
        format.html { redirect_to(edit_admin_taxonomy_path(@taxonomy), :notice => 'Taxonomy was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @taxonomy = Taxonomy.find(params[:id])

    respond_to do |format|
      if @taxonomy.update_attributes(params[:taxonomy])
        format.html { redirect_to(edit_admin_taxonomy_path(@taxonomy), :notice => 'Taxonomy was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @taxonomy = Taxonomy.find(params[:id])
    @taxonomy.destroy

    respond_to do |format|
      format.html { redirect_to(admin_taxonomies_path, :notice => 'Taxonomy successfully deleted') }
    end
  end

end
