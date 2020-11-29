module Dottie::Result
  class Success
    attr_reader :test_name

    def initialize(test_name)
      @test_name = test_name
    end

    def success?
      true
    end

    def skipped?
      false
    end

    def expected_failure?
      false
    end

    def failure?
      false
    end
  end
end
