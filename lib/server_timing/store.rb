module ServerTiming
  class Store
    attr_reader :metrics

    def initialize
    end

    def track!(metrics, options={})
      @metrics = metrics
    end
  end
end