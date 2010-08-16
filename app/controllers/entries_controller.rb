class EntriesController < ApplicationController
  
  def create
    @current_guide.add_entry(params[:type], params[:id])
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
