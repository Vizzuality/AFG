# see css_asset_tagger_options.rb for tagger options

config.to_prepare do
  CssAssetTaggerOptions.perform_tagging = Rails.env.production?
  CssAssetTaggerOptions.css_paths = %W(#{RAILS_ROOT}/public/stylesheets)
  CssAssetTaggerOptions.asset_path = "#{RAILS_ROOT}/public"
  CssAssetTaggerOptions.show_warnings = Rails.env.development?

  CssAssetTagger.tag(CssAssetTaggerOptions.css_paths) if CssAssetTaggerOptions.perform_tagging
end
