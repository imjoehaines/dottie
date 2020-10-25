module Dottie
  class TestCase
    attr_reader :test
    attr_reader :file
    attr_reader :expect
    attr_reader :result

    def initialize(test_type, runner, test:, file:, expect:)
      @test_type = test_type
      @runner = runner
      @test = test
      @file = file
      @expect = expect
    end

    def run
      @result = @runner.run(@test_type.command, @file)

      @expect == @result
    end
  end
end
