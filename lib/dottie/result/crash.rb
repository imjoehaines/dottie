module Dottie::Result
  class Crash
    attr_reader :test_name
    attr_reader :exception

    def initialize(test_name, exception)
      @test_name = test_name
      @exception = exception
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
      true
    end
  end
end
