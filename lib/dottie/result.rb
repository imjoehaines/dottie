module Dottie
  class Result
    class << self
      def success(test_case)
        self.new(test_case.test, test_case.expected, test_case.result, :success)
      end

      def skipped(test_case)
        self.new(test_case.test, test_case.expected, test_case.result, :skipped)
      end

      def failure(test_case)
        self.new(test_case.test, test_case.expected, test_case.result, :failure)
      end

      def expected_failure(test_case)
        self.new(test_case.test, test_case.expected, test_case.result, :expected_failure)
      end

      private

      def new(...)
        super
      end
    end

    attr_reader :test_name
    attr_reader :expected_output
    attr_reader :actual_output

    def success?
      @type == :success
    end

    def skipped?
      @type == :skipped
    end

    def expected_failure?
      @type == :expected_failure
    end

    def failure?
      @type == :failure
    end

    def initialize(test_name, expected_output, actual_output, type)
      @test_name = test_name
      @expected_output = expected_output
      @actual_output = actual_output
      @type = type
    end
  end
end
