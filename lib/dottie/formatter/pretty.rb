require_relative "simple"

module Dottie::Formatter
  class Pretty < Simple
    def test_result(result)
      directory = colour(result.directory).dim

      "#{super(result)} #{directory} #{result.test_name.chomp}\n"
    end
  end
end
