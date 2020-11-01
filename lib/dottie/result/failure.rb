require_relative "../result"

module Dottie::Result
  class Failure
    attr_reader :test_case

    def initialize(test_case)
      @test_case = test_case
    end

    def success?; false end
    def skipped?; false end
    def failed?; true end
  end
end
