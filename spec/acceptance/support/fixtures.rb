module FixturesMethods
  def create_guide(attributes)
    Guide.create(attributes)
  end
  def create_species(attributes)
    Species.create(attributes)
  end
  def create_picture(attributes = nil)
    Picture.create(attributes)
  end

  def create_penguin
    create_species  :name        => 'Penguin',
                    :kingdom     => 'Animalia',
                    :t_order     => 'Ciconiiformes',
                    :t_class     => 'Aves',
                    :genus       => 'Pygoscelis',
                    :phylum      => 'Chordata',
                    :family      => 'Spheniscidae',
                    :species     => 'Pygoscelis adeliae',
                    :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut
labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
  end
end

RSpec.configuration.include(FixturesMethods)
