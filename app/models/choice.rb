class Choice < ActiveRecord::Base
  
  belongs_to :guide, :counter_cache => :species_count
  belongs_to :species, :counter_cache => :guides_count
  
end
