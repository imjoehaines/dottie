require_relative "../result"

module Dottie::Result
  class Skipped
    attr_reader :test_case

    def initialize(test_case)
      @test_case = test_case
    end

    def success?; false end
    def skipped?; true end
    def failed?; false end
  end
end
