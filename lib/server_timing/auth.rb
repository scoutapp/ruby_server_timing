module ServerTiming
  # Encapsulates logic that determines whether the user is properly authorized to view server timing response headers.
  class Auth
    def self.ok!
      self.state=true
    end

    def self.deny!
      self.state=false
    end

    def self.reset!
      self.state=nil
    end

    def self.state=(new_state)
      Thread.current[:server_timing_authorized] = new_state
    end

    # Can be one of three values:
    # * true
    # * false
    # * nil (default)
    def self.state
      Thread.current[:server_timing_authorized]
    end

    def self.permitted?
      if state
        return true
      elsif state.is_a?(FalseClass)
        return false
      else # implied access - state has not been set
        # If not Rails, return true
        return true if !ServerTiming.rails?

        # If in a non-production environment, permit
        return true if !Rails.env.production?

        # In production, return false if no state has been set
        return false if Rails.env.production?
      end

    end
  end
end