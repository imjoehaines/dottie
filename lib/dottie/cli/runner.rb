require_relative "../../dottie"
require_relative "../colour"
require_relative "../parser"
require_relative "../runner"
require_relative "../stopwatch"
require_relative "../test_case"
require_relative "../thread_pool"
require_relative "../type"
require_relative "../validator"

module Dottie::Cli
  class Runner
    include Dottie::Colour

    def initialize(option_parser, print)
      @option_parser = option_parser
      @print = print
    end

    def run(argv)
      stopwatch = Dottie::Stopwatch.start

      begin
        config = @option_parser.parse(argv)
      rescue => error
        @print.(Dottie.banner(error: true), "\n\n")
        @print.("#{colour("Error").red.bold} #{error}", "\n\n")
        @print.(@option_parser.help)

        return 1
      end

      directory = argv.fetch(0, "tests")

      if File.directory?(directory)
        test_files = Dir["#{directory}/**/*.*t"]
      else
        test_files = [directory]
      end

      if test_files.empty?
        @print.(Dottie.banner(error: true), "\n\n")
        @print.(config.formatter.no_tests_found("#{__dir__}/#{directory}"))

        return 1
      end

      @print.(Dottie.banner, "\n\n")

      results = []
      exit_code = 0
      parser = Dottie::Parser.new(Dottie::Validator.new)
      pool = Dottie::ThreadPool.new(max_threads: config.max_threads)

      test_files.each do |path|
        pool.execute do
          sections = File.open(path) { |file| parser.parse(file) }
          type = Dottie::Type.for(File.extname(path))
          runner = Dottie::Runner.for(type)

          test_case = Dottie::TestCase.new(**sections)
          result = test_case.run(runner)

          @print.(config.formatter.test_result(result))

          exit_code = 1 if result.failed?

          results << result
        end
      end

      pool.finish!
      time_taken = stopwatch.time_taken

      @print.(config.formatter.suite_result(results, time_taken))

      exit_code
    end
  end
end
