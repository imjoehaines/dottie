require_relative "../colour"
require_relative "simple"

module Dottie::Formatter
  class Pretty < Simple
    def test_result(test_case, result)
      "#{super(test_case, result)} #{test_case.test.rstrip}\n"
    end
  end
end
