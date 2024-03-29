module Dottie::Result
  class Timeout
    attr_reader :directory
    attr_reader :test_name

    def initialize(directory, test_name)
      @directory = directory
      @test_name = test_name
    end

    def success?
      false
    end

    def skipped?
      false
    end

    def expected_failure?
      false
    end

    def failure?
      true
    end

    def crash?
      false
    end

    def timeout?
      true
    end
  end
end
