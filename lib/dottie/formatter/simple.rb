require_relative "../diff"
require_relative "../colour"
require_relative "../formatter"
require_relative "../time_formatter"

module Dottie::Formatter
  class Simple
    include Dottie::Colour

    def initialize(config)
      @config = config
      @diff = Dottie::Diff.new
    end

    def test_result(result)
      case
      when result.success?
        colour("✔").green.to_s
      when result.skipped?
        colour("-").cyan.to_s
      when result.expected_failure?
        colour("!").yellow.bold.to_s
      when result.failure?
        colour("✖").red.to_s
      else
        raise "Invalid result: #{result}"
      end
    end

    def suite_result(results, time_taken)
      total = results.count
      skips = results.count(&:skipped?)
      expected_failures = results.filter(&:expected_failure?)
      failures = results.filter(&:failure?)

      output = "\n"

      if failures.count > 0
        output << "#{colour("Failures:").bold}\n\n"

        failures.each do |failure|
          output << generate_failure_output(failure)
        end
      end

      output << "Ran " << colour("#{total} #{plural(total)}").bold.to_s
      output << " in " << colour(Dottie::TimeFormatter.format(time_taken)).bold.to_s
      output << "\n"

      if skips > 0
        output << colour("#{skips} skipped #{plural(skips)}").cyan.to_s << "\n"
      end

      if expected_failures.count > 0
        output << colour("#{expected_failures.count} #{plural(expected_failures.count, "expected failure")}").yellow.to_s << "\n"
      end

      if failures.count > 0
        output << colour("#{failures.count} failed #{plural(failures.count)}").red.to_s << "\n"
      end

      output << "\n" << success_or_fail(success: failures.count == 0) << "\n"

      output
    end

    def no_tests_found(directory)
      <<~TEXT
        No tests found in '#{directory}'

        #{success_or_fail(success: false)}
      TEXT
    end

    def directory_not_found(directory)
      <<~TEXT
        Directory not found '#{directory}'

        #{success_or_fail(success: false)}
      TEXT
    end

    private

    def success_or_fail(success:)
      if success
        colour("SUCCESS").green.bold.to_s
      else
        colour("FAIL").red.bold.to_s
      end
    end

    def plural(count, word = "test")
      return word if count == 1

      "#{word}s"
    end

    def generate_failure_output(failure)
      if failure.crash?
        <<~TEXT
          #{colour("✖ Crash!").red} #{failure.test_name.chomp}

          #{colour(failure.exception).bold}
            #{colour(failure.exception.backtrace.join("\n  ")).dim}

        TEXT
      elsif failure.timeout?
        <<~TEXT
          #{colour("✖").red} #{failure.test_name.chomp}

          #{colour("Test timed out after #{@config.timeout} seconds").bold}

        TEXT
      else
        begin
          <<~TEXT
            #{colour("✖").red} #{failure.test_name.chomp}

            #{colour("Diff:").bold}
            #{make_diff(failure.expected, failure.actual)}

          TEXT
        rescue
          <<~TEXT
            #{colour("✖").red} #{failure.test_name.chomp}

            #{colour("Failed to generate diff!").bold}

            #{colour("Expected:").bold}
            #{failure.expected}
            #{colour("Actual:").bold}
            #{failure.actual}
          TEXT
        end
      end
    end

    def make_diff(expected, actual)
      differences = @diff.generate(expected, actual)

      differences.map! do |line|
        case
        when line.start_with?("+")
          colour(line).green
        when line.start_with?("-")
          colour(line).red
        else
          line
        end
      end

      differences.join("\n")
    end
  end
end
