require_relative "../../dottie"
require_relative "../colour"
require_relative "../parser"
require_relative "../runner"
require_relative "../test_case"
require_relative "../type"
require_relative "../validator"

module Dottie::Cli
  class Runner
    def initialize(option_parser, print)
      @option_parser = option_parser
      @print = print
    end

    def run(argv)
      begin
        config = @option_parser.parse(argv)
      rescue => error
        @print.(Dottie.banner(error: true), "\n\n")
        @print.("#{Dottie::Colour.new("Error").red.bold} #{error}", "\n\n")
        @print.(@option_parser.help)

        return 1
      end

      directory = argv.fetch(0, "tests")
      test_files = Dir["#{directory}/**/*.*t"]

      if test_files.empty?
        @print.(Dottie.banner(error: true), "\n\n")
        @print.(config.formatter.no_tests_found("#{__dir__}/#{directory}"))

        return 1
      end

      @print.(Dottie.banner, "\n\n")

      results = []
      exit_code = 0
      parser = Dottie::Parser.new(Dottie::Validator.new)

      test_files.each do |path|
        sections = File.open(path) { |file| parser.parse(file) }
        type = Dottie::Type.for(File.extname(path))
        runner = Dottie::Runner.for(type)

        test_case = Dottie::TestCase.new(**sections)
        result = test_case.run(runner)

        @print.(config.formatter.test_result(result))

        exit_code = 1 if result.failed?

        results << result
      end

      @print.(config.formatter.suite_result(results))

      exit_code
    end
  end
end
