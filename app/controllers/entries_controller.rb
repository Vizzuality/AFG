class EntriesController < ApplicationController
  
  def index
    @entries = @current_guide.entries.paginate :page => params[:entry_page], :per_page => 5
    respond_to do |format|
      format.html
      format.js do
        render :update do |page|
          page << "$('#your_guide').html('#{escape_javascript(render(:partial => 'guides/your_guide'))}');"
          page << "AFG.behaviour();"
        end
      end
    end
  end
  
  def create
    @entry = @current_guide.add_entry(params[:type], params[:id])
    flash[:notice] = if @entry.is_a?(Array)
      "#{@entry.size} entries added to your guide <a class=\"undo\" href=\"#{undo_guide_path(@current_guide)}\">(undo)</a>"
    else
      case @entry.element_type
        when 'Species'
          "#{@entry.element.name} added to your guide <a class=\"undo\" href=\"#{undo_guide_path(@current_guide)}\">(undo)</a>"
        when 'Landscape'
          "#{@entry.element.name} added to your guide <a class=\"undo\" href=\"#{undo_guide_path(@current_guide)}\">(undo)</a>"
        else
          "#{@entry.elements_count} species added to your guide <a class=\"undo\" href=\"#{undo_guide_path(@current_guide)}\">(undo)</a>"
      end
    end
  ensure
    respond_to do |format|
      format.html do
        url = if @entry.is_a?(Array)
          guide_path(Guide.find_by_id(params[:id]))
        else
          case @entry.element_type
            when 'Species'
              species_path(@entry.element)
            when 'Landscape'
              landscape_path(@entry.element)
            else
              species_taxonomy_path(@entry.element.params_for_url)
          end
        end
        redirect_to url
      end
      format.js
    end
  end

  def destroy
    @entry = @current_guide.entries.find(params[:id])
    @entry.destroy
    flash[:notice] = case @entry.element_type
      when 'Species'
        "#{@entry.element.name} removed successfully"
      when 'Landscape'
        "#{@entry.element.name} removed successfully"
      when 'Guide'
        "#{@entry.element.name} removed successfully"
      else
        "#{@entry.elements_count} species removed successfully"
      end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'The entry you are trying to remove does not exist'
  ensure
    @entries = @current_guide.entries.paginate :page => params[:entry_page]
    respond_to do |format|
      format.html do
        redirect_to :back
      end
    end
  end

end
