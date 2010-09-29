class Admin::SpeciesController < ApplicationController

  layout 'admin'

  before_filter :admin_authenticated

  # GET /admin_species
  def index
    @species = if params[:complete]
      if params[:complete] == 'true'
        Species.complete
      else
        Species.pending
      end
    else
      Species
    end
    if params[:q]
      @species = @species.find_by_term(params[:q])
    end
    @species = @species.paginate(:per_page => 20, :page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /admin_species/new
  def new
    @species = Species.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /admin_species/1/edit
  def edit
    @species = Species.find(params[:id])
  end

  # POST /admin_species
  def create
    @species = Species.new(params[:species])

    respond_to do |format|
      if @species.save
        format.html { redirect_to(edit_admin_species_path(@species.id), :notice => 'Species was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update_uid_and_taxon
    @species = Species.find(params[:id])
    if @species.uid = Species.get_uid(params[:name])
      @species.name = params[:name]
      @species.save
      @species.get_taxon
      if @species.save
        redirect_to(edit_admin_species_path(@species.id), :notice => 'Species uid and taxonomy updated') and return
      else
        redirect_to(edit_admin_species_path(@species.id), :alert => 'Species uid wasn\'t updated') and return
      end
    else
      redirect_to(edit_admin_species_path(@species.id), :alert => 'Species uid wasn\'t updated') and return
    end
  end

  # PUT /admin_species/1
  def update
    @species = Species.find(params[:id])
    respond_to do |format|
      @species.attributes = (params[:species])
      if @species.save
        format.html { redirect_to(edit_admin_species_path(@species.id), :notice => 'Species was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /admin_species/1
  def destroy
    @species = Species.find(params[:id])
    @species.destroy

    respond_to do |format|
      format.html { redirect_to(admin_species_index_path, :notice => 'Species removed successfully') }
    end
  end

end
