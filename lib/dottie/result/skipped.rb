module Dottie::Result
  class Skipped
    attr_reader :test_name

    def initialize(test_name)
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
  end
end
