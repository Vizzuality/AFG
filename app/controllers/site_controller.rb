class SiteController < ApplicationController
  
  def home
    @pictures = if Species.highlighted.count > 0 
      Species.complete.highlighted.limit(5).map{|s| s.picture}.compact.flatten
    end
    @species = Species.complete.limit(6).order("featured DESC")
    @guides = Guide.highlighted.limit(3)
    @activities = Entry.limit(10).order('created_at DESC').delete_if{ |e| e.element.nil? }
  end
  
  def about
  end
  
end
