require_relative "../../dottie"
require_relative "../colour"
require_relative "../parser"
require_relative "../runner"
require_relative "../test_case"
require_relative "../type"
require_relative "../validator"

module Dottie::Cli
  class Runner
    def initialize(option_parser)
      @option_parser = option_parser
    end

    def run(argv)
      begin
        options = @option_parser.parse(argv)
      rescue => error
        puts Dottie.banner(error: true), "\n"
        puts "#{Dottie::Colour.new("Error").red.bold} #{error}", "\n"

        puts @option_parser.help
        exit 1
      end

      puts Dottie.banner, "\n"

      parser = Dottie::Parser.new(Dottie::Validator.new)

      results = []
      exit_code = 0
      directory = argv.fetch(0, "tests")
      test_files = Dir["#{directory}/**/*.*t"]

      if test_files.empty?
        print options.formatter.no_tests_found("#{__dir__}/#{directory}")

        exit 1
      end

      test_files.each do |path|
        sections = File.open(path) { |file| parser.parse(file) }
        type = Dottie::Type.for(File.extname(path))
        runner = Dottie::Runner.for(type)

        test_case = Dottie::TestCase.new(**sections)
        result = test_case.run(runner)

        print options.formatter.test_result(test_case, result)

        exit_code = 1 if result.failed?

        results << result
      end

      print options.formatter.suite_result(results)

      exit exit_code
    end
  end
end
