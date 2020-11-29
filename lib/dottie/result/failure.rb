module Dottie::Result
  class Failure
    attr_reader :test_name
    attr_reader :expected_output
    attr_reader :actual_output

    def initialize(test_name, expected_output, actual_output)
      @test_name = test_name
      @expected_output = expected_output
      @actual_output = actual_output
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
  end
end
