class Admin::SpeciesController < ApplicationController
  
  layout 'admin'
  
  before_filter :admin_authenticated
  
  # GET /admin_species
  def index
    @species = Species.paginate(:per_page => 20, :page => params[:page])

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

  # PUT /admin_species/1
  def update
    @species = Species.find(params[:id])

    respond_to do |format|
      if @species.update_attributes(params[:species])
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
      format.html { redirect_to(admin_species_url) }
    end
  end
end
