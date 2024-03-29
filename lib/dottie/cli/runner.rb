require_relative "../../dottie"
require_relative "../colour"
require_relative "../command"
require_relative "../parser"
require_relative "../result/crash"
require_relative "../result/timeout"
require_relative "../runner"
require_relative "../stopwatch"
require_relative "../test_case"
require_relative "../thread_pool"
require_relative "../validator"
require_relative "./directory_not_found"

module Dottie::Cli
  class Runner
    include Dottie::Colour

    def initialize(option_parser)
      @option_parser = option_parser
    end

    def run(argv)
      stopwatch = Dottie::Stopwatch.start

      begin
        config = @option_parser.parse(argv)
      rescue => error
        print(Dottie.banner(error: true), "\n\n")
        print("#{colour("Error").red.bold} #{error}", "\n\n")
        print(@option_parser.help)

        return 1
      end

      begin
        test_files = find_test_files(config)
      rescue DirectoryNotFound => e
        print(Dottie.banner(error: true), "\n\n")
        print(config.formatter.directory_not_found("#{__dir__}/#{e.directory}"))

        return 1
      end

      if test_files.empty?
        if config.test_directories.size == 1
          directory = config.test_directories.first
        else
          # use glob(ish) syntax when there are multiple directories
          # e.g. "__dir__/{a, b, c}"
          directory = "{#{config.test_directories.join(", ")}}"
        end

        print(Dottie.banner(error: true), "\n\n")
        print(config.formatter.no_tests_found("#{__dir__}/#{directory}"))

        return 1
      end

      print(Dottie.banner, "\n\n")

      results = []
      exit_code = 0
      parser = Dottie::Parser.new(Dottie::Validator.new)
      pool = Dottie::ThreadPool.new(max_threads: config.max_threads)

      test_files.each do |path|
        pool.execute do
          sections = File.open(path) { |file| parser.parse(file) }
          command = Dottie::Command.for(File.extname(path))
          runner = Dottie::Runner.for(command, config.timeout)

          test_case = Dottie::TestCase.new(**sections)

          result =
            begin
              test_case.run(runner)
            rescue Timeout::Error
              Dottie::Result::Timeout.new(sections[:directory], sections[:test])
            end

          print(config.formatter.test_result(result))

          exit_code = 1 if result.failure?

          results << result
        rescue => exception
          exit_code = 70
          test_name = test_case ? test_case.test : path

          results << Dottie::Result::Crash.new(File.dirname(path), test_name, exception)
        end
      end

      pool.finish!
      time_taken = stopwatch.time_taken

      print(config.formatter.suite_result(results, time_taken))

      exit_code
    end

    private

    def find_test_files(config)
      config.test_directories.flat_map do |directory|
        raise DirectoryNotFound.for(directory) unless File.exist?(directory)

        if File.directory?(directory)
          Dir["#{directory}/**/*.*t"]
        else
          [directory]
        end
      end
    end
  end
end
