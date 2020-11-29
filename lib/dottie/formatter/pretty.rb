require_relative "simple"

module Dottie::Formatter
  class Pretty < Simple
    def test_result(result)
      "#{super(result)} #{result.test_name.chomp}\n"
    end
  end
end
