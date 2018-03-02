module ServerTiming
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      rack_response = @app.call(env)
      begin
        ResponseManipulator.new(env, rack_response).call
      rescue Exception => e
        # If anything went wrong at all, just bail out and return the unmodified response.
        puts("ServerTiming: Raised an exception: #{e.message}, #{e.backtrace}")
        rack_response
      ensure
        ServerTiming::Auth.deny!
      end

    end
  end
end