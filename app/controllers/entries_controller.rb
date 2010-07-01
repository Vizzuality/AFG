class EntriesController < ApplicationController
  
  def create
    if params[:type] == 'Guide' and guide = Guide.find(params[:id])
      @current_guide.included_guides << guide
      flash[:notice] = 'Guide added successfully'
    elsif params[:type] == 'Species' and species = Species.find(params[:id])
      @current_guide.species << species
      flash[:notice] = 'Species added successfully'
    else
      flash[:alert] = 'Bad parameters'
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
