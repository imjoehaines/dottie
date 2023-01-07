module Dottie::Result
  class Crash
    attr_reader :directory
    attr_reader :test_name
    attr_reader :exception

    def initialize(directory, test_name, exception)
      @directory = directory
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

    def timeout?
      false
    end
  end
end
