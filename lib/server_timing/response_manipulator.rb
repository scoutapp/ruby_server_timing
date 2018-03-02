module ServerTiming
  class ResponseManipulator
    attr_reader :rack_response
    attr_reader :rack_status, :rack_headers, :rack_body
    attr_reader :env

    def initialize(env, rack_response)
      @env = env
      @rack_response = rack_response

      @rack_status = rack_response[0]
      @rack_headers = rack_response[1]
      @rack_body = rack_response[2]
    end

    def call
      return rack_response unless preconditions_met?

      store_metrics
      add_header
      rebuild_rack_response
    end

    def preconditions_met?
      Auth.permitted?
    end

    def add_header
      rack_headers['Server-Timing'] = payload
    end

    def tracked_request
      @tracked_request ||= ScoutApm::RequestManager.lookup
    end

    def store
      @store ||= ServerTiming::Store.new
    end

    def store_metrics
      layer_finder = ScoutApm::LayerConverters::FindLayerByType.new(tracked_request)
      converters = [ScoutApm::LayerConverters::MetricConverter]
      walker = ScoutApm::LayerConverters::DepthFirstWalker.new(tracked_request.root_layer)
      converters = converters.map do |klass|
        instance = klass.new(ScoutApm::Agent.instance.context, tracked_request, layer_finder, store)
        instance.register_hooks(walker)
        instance
      end
      walker.walk
      converters.each {|i| i.record! }
    end

    def server_timing_metrics
      @server_timing_metrics ||= store.metrics.map { |meta, stats| TimingMetric.from_scout(meta,stats)}
    end


    def payload
      headers = server_timing_metrics.map(&:to_header)
      headers << TimingMetric.new('Total', server_timing_metrics.map(&:duration).reduce(0,:+)).to_header
      headers.join(",")
    end

    def rebuild_rack_response
      [rack_status, rack_headers, rack_body]
    end
  end
end