module ServerTiming
  # Encapsulates a single metric that should be sent inside the server timing response header.
  class TimingMetric
    attr_reader :name
    attr_reader :duration
    attr_reader :description

    def self.from_scout(meta,stats)
      name = meta.type
      duration = stats.total_exclusive_time*1000
      new(name, duration)
    end

    def initialize(name,duration, description: nil)
      @name        = name
      @duration    = duration
      @description = description
    end

    def to_header
      "#{name}; dur=#{duration.to_d.truncate(2).to_f}; #{description_to_header}"
    end

    def description_to_header
      return unless description
      "desc=\"#{description}\";"
    end
  end
end