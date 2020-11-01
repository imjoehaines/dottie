require_relative "result/failure"
require_relative "result/skipped"
require_relative "result/success"

module Dottie::Result
  class << self
    def success(test_case)
      Success.new(test_case)
    end

    def failure(test_case)
      Failure.new(test_case)
    end

    def skipped(test_case)
      Skipped.new(test_case)
    end
  end
end
