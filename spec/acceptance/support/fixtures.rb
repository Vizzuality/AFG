module FixturesMethods
  def create_guide(attributes)
    Guide.create(attributes)
  end
end

RSpec.configuration.include(FixturesMethods)
