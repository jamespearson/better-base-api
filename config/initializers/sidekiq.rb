Sidekiq.configure_server do |config|
  config.redis = {url: Rails.ApplicationRecord.credentials.dig(:sidekiq, :redis_url)}
end

Sidekiq.configure_client do |config|
  config.redis = {url: Rails.ApplicationRecord.credentials.dig(:sidekiq, :redis_url)}
end
