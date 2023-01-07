require "optparse"
require_relative "../../dottie"
require_relative "../configuration"
require_relative "../formatter"

module Dottie::Cli
  class OptionParser
    def initialize
      defaults = Dottie::Configuration.new

      @raw_option_parser = ::OptionParser.new do |opts|
        opts.banner = "Usage: #{$PROGRAM_NAME} [file/directory] [<options>]"
        opts.separator ""

        opts.accept(Dottie::Formatter) do |formatter|
          Dottie::Formatter.for(formatter.to_sym).new(@config)
        end

        default_formatter = defaults.formatter.class.name.split("::").last.downcase

        opts.on(
          "-fFORMATTER",
          "--formatter=FORMATTER",
          Dottie::Formatter,
          "Choose a formatter for output (default: #{default_formatter})"
        ) do |formatter|
          @config.formatter = formatter
        end

        opts.on(
          "-jMAX_THREADS",
          "--max-threads=MAX_THREADS",
          ::OptionParser::DecimalInteger,
          "Set the maximum number of threads that can be used to run tests (default: #{defaults.max_threads})"
        ) do |max_threads|
          raise "--max-threads must be a positive integer" if max_threads <= 0

          @config.max_threads = max_threads
        end

        opts.on(
          "-tTIMEOUT",
          "--timeout=TIMEOUT",
          ::OptionParser::DecimalInteger,
          "Set the maximum time in seconds any single test is allowed to run (default: #{defaults.timeout})"
        ) do |timeout|
          raise "--timeout must be a positive integer" if timeout <= 0

          @config.timeout = timeout
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
    end

    def parse(argv)
      @config = Dottie::Configuration.new

      @raw_option_parser.parse!(argv)

      # if there are any remaining arguments they are directories to look for
      # tests in
      if argv.size > 0
        # remove trailing '/' from directory names
        @config.test_directories = argv.map { |directory| directory.delete_suffix("/") }
      end

      @config
    end

    def help
      @raw_option_parser.help
    end
  end
end
