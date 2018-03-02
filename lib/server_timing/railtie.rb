module ServerTiming
  class Railtie < Rails::Railtie
    initializer "server_timing.configure_rails_initialization" do |app|
      app.middleware.use ServerTiming::Middleware
    end
  end
end