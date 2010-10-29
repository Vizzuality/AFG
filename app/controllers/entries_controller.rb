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
    notice = if @entry.is_a?(Array)
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
        flash[:notice] = notice
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
      format.js do
        flash.now[:notice] = notice
        set_current_guide
        render :update do |page|
          partial = case @entry.element_type
            when 'Species'
              @species = @entry.element
              'species/add_to_guide'
            when 'Landscape'
              @landscape = @entry.element
              'landscapes/add_to_guide'
            else
              @taxonomy = @entry.element
              'species/add_taxonomy_to_guide'
          end
          
          page << "$('#your_guide').html('#{escape_javascript(render(:partial => 'guides/your_guide'))}');"
          page << "$('#add_to_guide_#{@entry.element.class.name.downcase}').html('#{escape_javascript(render(:partial => partial))}');"
          page << "$('#pop_up').html('#{render :inline => '<%= pop_up_flash %>'}')";
          if !@entry.is_a?(Array) && @entry.element.respond_to?(:guides_count)
            page << "$('#times_added_#{@entry.element.class.name.downcase}').html('#{render :inline => '<%= pluralize(@entry.element.guides_count, \'time\', \'times\') %> added'}');"
          end
          page << <<-JS
          
          
          
       		var xScroll, yScroll;
       		if (self.pageYOffset) {
       			yScroll = self.pageYOffset;
       			xScroll = self.pageXOffset;
       		} else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
       			yScroll = document.documentElement.scrollTop;
       			xScroll = document.documentElement.scrollLeft;
       		} else if (document.body) {// all other Explorers
       			yScroll = document.body.scrollTop;
       			xScroll = document.body.scrollLeft;	
       		}
        	
          // Calculate top and left offset for the jquery-lightbox div object and show it
     			$('.pop_up').css('top',yScroll);
     			$('.pop_up').css('right','21px');
          
          $('#pop_up').show();
          $('#pop_up').delay(3000).fadeOut();
          
JS
          if @taxonomy
            page << <<-JS
            if(document.getElementById("taxonomy_#{@taxonomy.id}")) {
              $('#taxonomy_#{@taxonomy.id}').html('<strong>#{@taxonomy.species_count}</strong> species, added');
            }
JS
          end
          if @species
            page << <<-JS
            if(document.getElementById("species_#{@species.id}")) {
              
              $('#species_#{@species.id}').html('added');
            }
            
            if(document.getElementById("li_species_#{@species.id}")) {
              $('li#li_species_#{@species.id}').children('div.info').children('a').addClass('added');
            }
JS
          end
        end
      end
    end
  end

  def destroy
    @entry = @current_guide.entries.find(params[:id])
    @entry.destroy
    notice = case @entry.element_type
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
    respond_to do |format|
      format.html do
        flash[:notice] = notice
        redirect_to :back
      end
      format.js do
        flash.now[:notice] = notice
        set_current_guide
        render :update do |page|
          partial = case @entry.element_type
            when 'Species'
              @species = @entry.element
              'species/add_to_guide'
            when 'Landscape'
              @landscape = @entry.element
              'landscapes/add_to_guide'
            else
              @taxonomy = @entry.element
              'species/add_taxonomy_to_guide'
          end
          page << "$('#your_guide').html('#{escape_javascript(render(:partial => 'guides/your_guide'))}');"
          page << "$('#add_to_guide_#{@entry.element.class.name.downcase}').html('#{escape_javascript(render(:partial => partial))}');"
          page << "$('#pop_up').html('#{render :inline => '<%= pop_up_flash %>'}')";          
          if !@entry.is_a?(Array) && @entry.element.respond_to?(:guides_count)
            page << "$('#times_added_#{@entry.element.class.name.downcase}').html('#{render :inline => '<%= pluralize(@entry.element.guides_count, \'time\', \'times\') %> added'}');"
          end
          page << <<-JS
          
          var xScroll, yScroll;
       		if (self.pageYOffset) {
       			yScroll = self.pageYOffset;
       			xScroll = self.pageXOffset;
       		} else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
       			yScroll = document.documentElement.scrollTop;
       			xScroll = document.documentElement.scrollLeft;
       		} else if (document.body) {// all other Explorers
       			yScroll = document.body.scrollTop;
       			xScroll = document.body.scrollLeft;	
       		}
               	
          // Calculate top and left offset for the jquery-lightbox div object and show it          
     			$('.pop_up').css('top',yScroll);
     			$('.pop_up').css('right','21px');

          $('#pop_up').show();
          $('#pop_up').delay(3000).fadeOut();
          
JS

          if @taxonomy
            page << <<-JS
            if(document.getElementById("taxonomy_#{@taxonomy.id}")) {
              $('#taxonomy_#{@taxonomy.id}').html('<strong>#{@taxonomy.species_count}</strong> species, <a href="#{create_entry_path(:type => @taxonomy.hierarchy.humanize, :id => @taxonomy.name)}" class="add" data-remote="true">add</a>');
            }
JS
          end
          if @species
            page << <<-JS
            if(document.getElementById("species_#{@species.id}")) {
              $('#species_#{@species.id}').html('<a href="#{create_entry_path(:type => 'Species', :id => @species.id)}" class="add" data-remote="true">add</a>');
            }
            
            if(document.getElementById("li_species_#{@species.id}")) {
              $('li#li_species_#{@species.id}').children('div.info').children('a').removeClass('added');
            }
JS
          end
        end
      end
    end
  end

end
