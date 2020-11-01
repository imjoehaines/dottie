require_relative "../time_formatter"
require_relative "../colour"

module Dottie::Formatter
  class Simple
    include Dottie::Colour

    def test_result(result)
      if result.success?
        colour("✔").green.to_s
      elsif result.skipped?
        colour("-").cyan.to_s
      else
        colour("✖").red.to_s
      end
    end

    def suite_result(results, time_taken)
      total = results.count
      skips = results.count(&:skipped?)
      failures = results.filter(&:failed?)
      plural = ->(count) { count == 1 ? "test" : "tests" }

      output = "\n"

      if failures.count > 0
        output << "#{colour("Failures:").bold}\n\n"

        failures.each do |failure|
          output << <<~TEXT
            #{colour("✖").red} #{failure.test_case.test}
            #{colour("Expected output:").bold}
            #{failure.test_case.expected}
            #{colour("Actual output:").bold}
            #{failure.test_case.result}
          TEXT
        end
      end

      output << "Ran " << colour("#{total} #{plural.(total)}").bold.to_s
      output << " in " << colour(Dottie::TimeFormatter.format(time_taken)).bold.to_s
      output << "\n"

      if skips > 0
        output << colour("#{skips} skipped #{plural.(skips)}").cyan.to_s << "\n"
      end

      if failures.count > 0
        output << colour("#{failures.count} failed #{plural.(failures)}").red.to_s << "\n"
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
  end
end
