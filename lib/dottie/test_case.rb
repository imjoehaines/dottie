require_relative "result/expected_failure"
require_relative "result/failure"
require_relative "result/skipped"
require_relative "result/success"

module Dottie
  class TestCase
    attr_reader :test

    def initialize(
      directory:,
      test:,
      file:,
      expect: nil,
      expectf: nil,
      expectregex: nil,
      skipif: nil,
      xfail: nil,
      clean: nil,
      env: {}
    )
      if expect.nil? && expectf.nil? && expectregex.nil?
        raise "Invalid test case; no expect/expectf/expectregex given!"
      end

      @directory = directory
      @test = test
      @file = file
      @expect = expect
      @expectf = expectf
      @expectregex = expectregex
      @skipif = skipif
      @xfail = xfail
      @clean = clean
      @env = env
    end

    def run(runner)
      return Result::Skipped.new(@directory, @test) if should_skip?(runner)

      actual = runner.run(@file, @directory, @env)
      passed = success?(actual)

      case
      when @xfail && passed
        Result::Failure.new(@directory, @test, @xfail, actual)
      when @xfail
        Result::ExpectedFailure.new(@directory, @test)
      when passed
        Result::Success.new(@directory, @test)
      else
        Result::Failure.new(@directory, @test, expected, actual)
      end
    ensure
      runner.run(@clean, @directory) if @clean
    end

    private

    def expected
      case
      when @expect then @expect
      when @expectf then @expectf
      when @expectregex then @expectregex
      else raise "Invalid test case; no expected result given!"
      end
    end

    def success?(actual)
      case
      when @expect then @expect == actual
      when @expectf then expectf_matches?(actual)
      when @expectregex then expectregex_matches?(actual)
      else false
      end
    end

    def should_skip?(runner)
      return false if @skipif.nil?

      output = runner.run(@skipif, @directory)

      output.downcase.start_with?("skip")
    end

    ##
    # Supported PHPT format specifiers:
    #   %d: an unsigned integer
    #   %i: a signed integer
    #   %f: a float
    #   %c: a single character
    #   %s: one or more of anything until a newline
    #   %S: zero or more of anything until a newline
    #   %a: one or more of anything including newlines
    #   %A: zero or more of anything including newlines
    #   %w: zero or more whitespace characters
    #   %x: one or more hexadecimal character (a-f, A-F, 0-9)
    #
    # Unsupported PHPT format specifiers:
    #   %r...%r: a regular expression
    def expectf_matches?(actual)
      raise "No expectf given but expectf_matches? called??" unless @expectf

      regex_string = Regexp.quote(@expectf.dup)
      regex_string.gsub!(/([^%])?%d/, '\1\d+')
      regex_string.gsub!(/([^%])?%i/, '\1[-+]?\d+')
      regex_string.gsub!(/([^%])?%f/, '\1\d+.\d+')
      regex_string.gsub!(/([^%])?%c/, '\1.')
      regex_string.gsub!(/([^%])?%s/, '\1.+')
      regex_string.gsub!(/([^%])?%S/, '\1.*')
      regex_string.gsub!(/([^%])?%a/, '\1(.|\R)+?')
      regex_string.gsub!(/([^%])?%A/, '\1(.|\R)*?')
      regex_string.gsub!(/([^%])?%w/, '\1\s')
      regex_string.gsub!(/([^%])?%x/, '\1[a-fA-F0-9]+')
      regex_string.gsub!("%%", "%")

      regex = Regexp.new('\A' << regex_string << '\z')

      regex.match?(actual)
    end

    def expectregex_matches?(actual)
      regex = Regexp.new('\A' << @expectregex << '\z')

      regex.match?(actual)
    end
  end
end
