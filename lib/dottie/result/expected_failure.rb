module Dottie::Result
  class ExpectedFailure
    attr_reader :test_name

    def initialize(test_name)
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
  end
end
