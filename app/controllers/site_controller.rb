class SiteController < ApplicationController
  
  def home
    @pictures = if Species.highlighted.count > 0 
      Species.complete.highlighted.limit(5).map{|s| s.pictures.first}
    else
      Picture.limit(5)
    end
    @activities = Activity.limit(10).order('created_at DESC')
  end
  
  def about
  end
  
end
