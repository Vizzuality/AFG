class SiteController < ApplicationController
  
  def home
    @pictures = Picture.find_random(5)
  end
  
  def about
  end
  
end
