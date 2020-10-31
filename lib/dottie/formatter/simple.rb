require_relative "../colour"

module Dottie::Formatter
  class Simple
    def test_result(test_case, result)
      if result.success?
        colour("✔").green.to_s
      elsif result.skipped?
        colour("-").cyan.to_s
      else
        colour("✖").red.to_s
      end
    end

    def suite_result(results)
      total = results.count
      skips = results.count(&:skipped?)
      failures = results.filter(&:failed?)
      plural = ->(count) { count == 1 ? "test" : "tests" }

      output = "\n#{colour("Failures:").bold}\n\n"

      failures.each do |failure|
        output << <<~TEXT
          #{colour("✖").red} #{failure.test_case.test}
          #{colour("Expected output:").bold}
          #{failure.test_case.expected}
          #{colour("Actual output:").bold}
          #{failure.test_case.result}
        TEXT
      end

      output << colour("Ran #{total} #{plural.(total)}!\n").bold.to_s

      if skips > 0
        output << colour("#{skips} skipped #{plural.(skips)}").cyan.to_s << "\n"
      end

      if failures.count > 0
        output << colour("#{failures.count} failed #{plural.(failures)}").red.to_s << "\n"
      end

      output << "\n" << success_or_fail(success: failures.count == 0)

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
        colour("SUCCESS\n").green.bold.to_s
      else
        colour("FAIL\n").red.bold.to_s
      end
    end

    def colour(*args); Dottie::Colour.new(*args) end
  end
end
