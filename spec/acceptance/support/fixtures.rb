module FixturesMethods
  def create_guide(attributes)
    Guide.create(attributes)
  end
  def create_species(attributes)
    Species.create(attributes)
  end
end

RSpec.configuration.include(FixturesMethods)
