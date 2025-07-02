# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Trong môi trường phát triển, ta có thể cho phép tất cả các domain
    # bằng cách dùng dấu '*'.
    # Khi deploy lên production, bạn nên thay '*' bằng domain của frontend
    # ví dụ: origins 'https://my-awesome-app.com'
    origins 'http://localhost:3001'

    resource '*', # Chỉ áp dụng CORS cho các route API
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization'], # Cho phép client đọc các header tùy chỉnh (nếu có)
      credentials: true # Nếu bạn cần gửi cookie hoặc thông tin xác thực khác
  end
end
