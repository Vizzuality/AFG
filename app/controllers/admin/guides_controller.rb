class Admin::GuidesController < ApplicationController
  
  layout 'admin'
  
  before_filter :admin_authenticated
  
  def index    
    @guides = if params[:q]
      Guide.find_by_term(params[:q])
    else
      Guide
    end
    @guides = @guides.paginate(:per_page => 20, :page => params[:page])
    respond_to do |format|
      format.html
    end
  end

  def edit
    @guide = Guide.find(params[:id])
  end

  def update
    @guide = Guide.find(params[:id])
    @guide.attributes = params[:guide]
    respond_to do |format|
      if @guide.save
        format.html { redirect_to(edit_admin_guide_path(@guide), :notice => 'Guide was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @guide = Guide.find(params[:id])
    @guide.destroy

    respond_to do |format|
      format.html { redirect_to(admin_guides_path, :notice => 'Guide successfully deleted') }
    end
  end

end
