module ServerTiming
  def self.rails?
    defined? Rails::Railtie
  end
end

require "server_timing/auth"
require "server_timing/middleware"
require "server_timing/railtie" if ServerTiming.rails?
require "server_timing/response_manipulator"
require "server_timing/store"
require "server_timing/timing_metric"
require "server_timing/version"