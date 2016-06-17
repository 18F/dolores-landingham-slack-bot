Rails.application.configure do
  config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))









  config.action_controller.perform_caching = true
  config.active_record.dump_schema_after_migration = false
  config.active_support.deprecation = :notify
  config.assets.compile = true
  config.assets.digest = true
  config.assets.js_compressor = :uglifier
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.eager_load = true
  config.i18n.fallbacks = true
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :debug
  config.middleware.use Rack::CanonicalHost, ENV.fetch("HOST")
  config.middleware.use Rack::Deflater
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
end

Rack::Timeout.timeout = (ENV["RACK_TIMEOUT"] || 10).to_i
