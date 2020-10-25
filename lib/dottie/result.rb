module Dottie
  class Result
    def initialize(success: false, skipped: false)
      @success = success
      @skipped = skipped
    end

    def success?
      @success
    end

    def skipped?
      @skipped
    end
  end
end
