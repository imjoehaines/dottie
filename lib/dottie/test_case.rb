require_relative "result"

module Dottie
  class TestCase
    attr_reader :test
    attr_reader :expect
    attr_reader :result

    def initialize(test_type, runner, test:, file:, expect:, skipif: nil)
      @test_type = test_type
      @runner = runner
      @test = test
      @file = file
      @expect = expect
      @skipif = skipif
    end

    def run
      return Result.new(skipped: true) if should_skip?

      @result = @runner.run(@test_type.command, @file)

      Result.new(success: @expect == @result)
    end

    private

    def should_skip?
      return false if @skipif.nil?

      output = @runner.run(@test_type.command, @skipif)

      output.downcase.start_with?("skip")
    end
  end
end
