require "open3"

module Dottie
  class TestCase
    attr_reader :test
    attr_reader :file
    attr_reader :expect
    attr_reader :result

    def initialize(test_type, test:, file:, expect:)
      @test_type = test_type
      @test = test
      @file = file
      @expect = expect
    end

    def run
      Open3.popen2e(@test_type.command) do |stdin, stdout, thread|
        stdin.puts(@file)
        stdin.close

        @result = stdout.read

        stdout.close
        thread.join
      end

      @expect == @result
    end
  end
end
