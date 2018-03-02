module ServerTiming
  # Encapsulates logic that determines whether the user is properly authorized to view server timing response headers.
  class Auth
    def self.required?
      return false unless defined? Rails::Railtie # will send headers by default for Rack apps

      return true if Rails.env.production? # Requires a call to `ServerTiming::Auth.ok!` for Rails apps in the production environment.

      false
    end

    def self.ok!
      Thread.current[:server_timing_authorized] = true
    end

    def self.deny!
      Thread.current[:server_timing_authorized] = nil
    end

    def self.state
      Thread.current[:server_timing_authorized]
    end

    def self.permitted?
      return true unless required?

      state
    end
  end
end