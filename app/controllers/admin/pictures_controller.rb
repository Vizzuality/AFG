class Admin::PicturesController < ApplicationController
  
  layout 'admin'
  
  before_filter :admin_authenticated
  before_filter :set_species
  
  # GET /admin_species/:species_id/pictures/new
  def new
    @picture = @species.pictures.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /admin_species/:species_id/pictures/:id/edit
  def edit
    @picture = @species.pictures.find(params[:id])
  end

  # POST /admin_species/:species_id/pictures
  def create
    @picture = @species.pictures.new(params[:picture])

    respond_to do |format|
      if @picture.save
        format.html { redirect_to(edit_admin_species_path(@species), :notice => 'Picture was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /admin_species/:species_id/pictures/:id
  def update
    @picture = @species.pictures.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to(edit_admin_species_path(@species), :notice => 'Picture was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /admin_species/:species_id/pictures/:id
  def destroy
    @picture = @species.pictures.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to(edit_admin_species_path(@species), :notice => 'Picture successfully deleted') }
    end
  end
  
  protected
  
    def set_species
      @species = Species.find(params[:species_id])
    end
end
