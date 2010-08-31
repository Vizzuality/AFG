require File.dirname(__FILE__)+'/../css_asset_tagger_options'
require File.dirname(__FILE__)+'/../css_asset_tagger'

namespace :css_asset_tagger do
  desc "Add asset timestamps to assets found in the project stylesheets"
  task :tag do
    CssAssetTagger.tag CssAssetTaggerOptions.css_paths
  end
end
