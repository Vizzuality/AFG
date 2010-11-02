module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    "/"
  end

  def guide(guide)
    "/guides/#{guide.to_param}"
  end

  def about
    '/about'
  end
end

RSpec.configuration.include(NavigationHelpers)
