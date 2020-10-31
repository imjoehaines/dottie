require_relative "../colour"
require_relative "simple"

module Dottie::Formatter
  class Pretty < Simple
    def test_result(test_case, result)
      if result.success?
        "#{colour("✔").green} #{test_case.test}"
      elsif result.skipped?
        "#{colour("-").cyan} #{test_case.test}"
      else
        <<~TEXT
          #{colour("✖").red} #{test_case.test}
          #{colour("Expected output:").bold}
          #{test_case.expected}
          #{colour("Actual output:").bold}
          #{test_case.result}
        TEXT
      end
    end
  end
end
