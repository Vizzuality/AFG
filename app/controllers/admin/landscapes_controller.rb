class Admin::LandscapesController < ApplicationController
  
  layout 'admin'
  
  before_filter :admin_authenticated
  
  def index    
    @landscapes = if params[:q]
      Landscape.find_by_term(params[:q])
    else
      Landscape
    end
    @landscapes = @landscapes.paginate(:per_page => 20, :page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def new
    @landscape = Landscape.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @landscape = Landscape.find(params[:id])
  end

  def create
    @landscape = Landscape.new(params[:landscape])

    respond_to do |format|
      if @landscape.save
        format.html { redirect_to(edit_admin_landscape_path(@landscape), :notice => 'Landscape was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @landscape = Landscape.find(params[:id])

    respond_to do |format|
      if @landscape.update_attributes(params[:landscape])
        format.html { redirect_to(edit_admin_landscape_path(@species), :notice => 'Landscape was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @landscape = Landscape.find(params[:id])
    @landscape.destroy

    respond_to do |format|
      format.html { redirect_to(admin_landscapes_path, :notice => 'Landscape successfully deleted') }
    end
  end

end
