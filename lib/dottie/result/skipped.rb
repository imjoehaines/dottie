module Dottie::Result
  class Skipped
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
      true
    end

    def expected_failure?
      false
    end

    def failure?
      false
    end

    def crash?
      false
    end

    def timeout?
      false
    end
  end
end
