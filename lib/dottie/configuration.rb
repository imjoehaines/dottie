require_relative "./formatter"

module Dottie
  class Configuration
    def formatter=(formatter)
      @formatter = formatter
    end

    def formatter
      @formatter ||= Dottie::Formatter.for(:pretty)
    end

    def max_threads=(max_threads)
      @max_threads = max_threads
    end

    def max_threads
      @max_threads ||= 8
    end
  end
end
