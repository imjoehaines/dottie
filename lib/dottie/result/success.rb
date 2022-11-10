module Dottie::Result
  class Success
    attr_reader :directory
    attr_reader :test_name

    def initialize(directory, test_name)
      @directory = directory
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

    def crash?
      false
    end
  end
end
