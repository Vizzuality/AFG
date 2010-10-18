HoptoadNotifier.configure do |config|
  config.api_key = '364cf4b6bf3b75ef9fa533c1ec0a24b4'
  config.js_notifier = true
  # Hide staging errors or not
  # config.development_environments = File.file?(Rails.root+'STAGING') ? %w(development test cucumber production) : %w(development test cucumber)
  config.environment_name = Rails.env.production? ? (File.file?(Rails.root+'STAGING') ? 'staging' : 'production') : Rails.env
end
