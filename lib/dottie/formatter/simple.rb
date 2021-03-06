require_relative "../colour"
require_relative "../formatter"
require_relative "../time_formatter"

module Dottie::Formatter
  class Simple
    include Dottie::Colour

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
          if failure.crash?
            output << <<~TEXT
              #{colour("✖ Crash!").red} #{failure.test_name.chomp}

              #{colour(failure.exception).bold}
                #{colour(failure.exception.backtrace.join("\n  ")).dim}

            TEXT
          else
            output << <<~TEXT
              #{colour("✖").red} #{failure.test_name}
              #{colour("Expected output:").bold}
              #{failure.expected_output}
              #{colour("Actual output:").bold}
              #{failure.actual_output}
            TEXT
          end
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
  end
end
