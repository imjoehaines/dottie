module Dottie::Result
  class Failure
    attr_reader :test_name
    attr_reader :expected
    attr_reader :actual

    def initialize(test_name, expected, actual)
      @test_name = test_name
      @expected = expected
      @actual = actual
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
  end
end
