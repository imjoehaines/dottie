require_relative "../result"

module Dottie::Result
  class Success
    attr_reader :test_case

    def initialize(test_case)
      @test_case = test_case
    end

    def success?; true end
    def skipped?; false end
    def failed?; false end
  end
end
