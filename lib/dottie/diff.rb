require "tempfile"

module Dottie
  class Diff
    def generate(a, b)
      with_temp_files(a, b) do |file_a, file_b|
        diff = `diff --unified=9999 #{file_a.path} #{file_b.path}`

        # diff exits with '0' if there are no differences, '1' if there is a
        # difference and '> 1' if there was an error
        if $?.exitstatus != 1
          raise "Failed to generate diff!"
        end

        lines = diff.split("\n")

        # remove file names, context markers and "\ No newline at end of file"
        lines.reject! do |line|
          line.start_with?("--- #{file_a.path}") ||
            line.start_with?("+++ #{file_b.path}") ||
            (line.start_with?("@@ ") && line.end_with?(" @@")) ||
            line.start_with?("\\ No newline at end of file")
        end

        lines
      end
    end

    def with_temp_files(a, b, &block)
      Tempfile.create("dottie-temp-a-") do |file_a|
        file_a.write(a)
        file_a.flush

        Tempfile.create("dottie-temp-b-") do |file_b|
          file_b.write(b)
          file_b.flush

          block.call(file_a, file_b)
        end
      end
    end
  end
end
