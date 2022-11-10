module Dottie::Result
  class ExpectedFailure
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
      true
    end

    def failure?
      false
    end

    def crash?
      false
    end
  end
end
