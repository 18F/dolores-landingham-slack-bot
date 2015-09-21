require File.expand_path('../application', __FILE__)
Rails.application.initialize!

Rails.application.configure do
  config.sass.preferred_syntax = :sass
  config.sass.line_comments = false
  config.sass.cache = false
end