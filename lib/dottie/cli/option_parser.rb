require "optparse"
require_relative "../configuration"
require_relative "../formatter"

module Dottie::Cli
  class OptionParser
    def initialize
      @raw_option_parser = ::OptionParser.new do |opts|
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
          @options.formatter = formatter
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
      @options = Dottie::Configuration.new

      @raw_option_parser.parse!(argv)

      @options
    end

    def help
      @raw_option_parser.help
    end
  end
end
