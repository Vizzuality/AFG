ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  
  def create_guide(attributes)
    Guide.create(attributes)
  end
  
  def create_species(attributes)
    Species.create(attributes)
  end
  
  def create_landscape(attributes)
    Landscape.create(attributes)
  end
  
end
