Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"
    resource "*", headers: :any, methods: [:get, :post, :options, :patch, :delete], expose: ["ETag", "Authorization"]
  end
end
