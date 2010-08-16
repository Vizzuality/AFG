class EntriesController < ApplicationController
  
  def create
    element = if params[:type] == 'Guide' and guide = Guide.find(params[:id])
      flash[:notice] = 'Guide added successfully'
      Entry.create :guide => @current_guide, :element_type => 'Guide', :element_id => guide.id
    elsif params[:type] == 'Species' and species = Species.complete.find(params[:id])
      flash[:notice] = 'Species added successfully'
    else
      nil
    end
    if element.nil?
      flash[:alert] = 'Bad parameters'
    else
      @current_guide.elements << element
    end
    
  rescue ActiveRecord::RecordNotFound
    message = if params[:type] == 'Guide'
      "The guide doesn't exist"
    else
      "The species doesn't exist"
    end
    flash[:error] = message
  ensure
    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js
    end
  end

  def destroy
    @current_guide.entries.find(params[:id]).destroy
    flash[:notice] = 'Entry removed successfully'
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'The entry you are trying to remove does not exist'
  ensure
    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js
    end
  end

end
