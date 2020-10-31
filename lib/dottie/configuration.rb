require_relative "./formatter"

module Dottie
  class Configuration
    def formatter=(formatter)
      @formatter = formatter
    end

    def formatter
      @formatter ||= Dottie::Formatter.for(:pretty)
    end
  end
end
