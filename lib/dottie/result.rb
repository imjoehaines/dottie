module Dottie
  class Result
    attr_reader :test_case

    def initialize(test_case:, success: false, skipped: false)
      @test_case = test_case
      @success = success
      @skipped = skipped
    end

    def success?
      @success
    end

    def skipped?
      @skipped
    end

    def failed?
      !success? && !skipped?
    end
  end
end
