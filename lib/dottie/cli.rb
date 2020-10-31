require "optparse"
require_relative "../dottie"
require_relative "./colour"
require_relative "./formatter"
require_relative "./parser"
require_relative "./runner"
require_relative "./test_case"
require_relative "./type"
require_relative "./validator"

module Dottie::Cli
  class << self
    def run
      options = {}

      option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{$PROGRAM_NAME} [directory] [<options>]"
        opts.separator ""

        opts.accept(Dottie::Formatter) do |formatter|
          Dottie::Formatter.for(formatter.to_sym)
        end

        opts.on(
          "-fFORMATTER",
          "--formatter=FORMATTER",
          Dottie::Formatter,
          "Choose a formatter for output (default: pretty)"
        ) do |formatter|
          options[:formatter] = formatter
        end

        opts.on("-h", "--help", "Show this help") do
          puts Dottie.banner, "\n"
          puts opts
          exit
        end

        opts.on("-v", "--version", "Output Dottie version number") do
          puts "Dottie #{Dottie::VERSION}"
          exit
        end
      end

      begin
        option_parser.parse!
      rescue => error
        puts Dottie.banner(error: true), "\n"
        puts "#{Dottie::Colour.new("Error").red.bold} #{error}", "\n"

        puts option_parser
        exit 1
      end

      puts Dottie.banner, "\n"

      formatter = options[:formatter] || Dottie::Formatter.for(:pretty)
      parser = Dottie::Parser.new(Dottie::Validator.new)

      results = []
      exit_code = 0
      directory = ARGV.fetch(0, "tests")
      test_files = Dir["#{directory}/**/*.*t"]

      if test_files.empty?
        print formatter.no_tests_found("#{__dir__}/#{directory}")

        exit 1
      end

      test_files.each do |path|
        sections = File.open(path) { |file| parser.parse(file) }
        type = Dottie::Type.for(File.extname(path))
        runner = Dottie::Runner.for(type)

        test_case = Dottie::TestCase.new(**sections)
        result = test_case.run(runner)

        print formatter.test_result(test_case, result)

        exit_code = 1 if result.failed?

        results << result
      end

      print formatter.suite_result(results)

      exit exit_code
    end
  end
end
