class SiteController < ApplicationController
  
  def home
    @pictures = if Species.highlighted.count > 0 
      Species.complete.highlighted.limit(5).map{|s| s.picture}
    end
    @activities = Entry.limit(10).order('created_at DESC')
  end
  
  def about
  end
  
end
