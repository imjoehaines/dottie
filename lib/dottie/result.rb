module Dottie
  class Result
    class << self
      def success(test_case)
        self.new(test_case, type: :success)
      end

      def failure(test_case)
        self.new(test_case, type: :failure)
      end

      def skipped(test_case)
        self.new(test_case, type: :skipped)
      end

      private

      def new(...)
        super
      end
    end

    attr_reader :test_case

    def success?
      @type == :success
    end

    def skipped?
      @type == :skipped
    end

    def failure?
      @type == :failure
    end

    def initialize(test_case, type:)
      @test_case = test_case
      @type = type
    end
  end
end
