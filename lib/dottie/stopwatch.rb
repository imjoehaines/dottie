module Dottie
  class Stopwatch
    class << self
      def start
        new(now)
      end

      def now
        Process.clock_gettime(Process::CLOCK_MONOTONIC_RAW, :nanosecond)
      end
    end

    def initialize(start_time)
      @start_time = start_time
    end

    def time_taken
      Stopwatch.now - @start_time
    end
  end
end
