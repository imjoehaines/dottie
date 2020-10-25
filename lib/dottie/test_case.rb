require "open3"

module Dottie
  class TestCase
    attr_reader :test
    attr_reader :file
    attr_reader :expect
    attr_reader :result

    def initialize(command, test:, file:, expect:)
      @command = command
      @test = test
      @file = file
      @expect = expect
    end

    def run
      Open3.popen2e(@command) do |stdin, stdout, thread|
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
