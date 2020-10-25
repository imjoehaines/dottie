require "open3"

module Dottie
  class Runner
    def run(command, input)
      result = nil

      Open3.popen2e(command) do |stdin, stdout, thread|
        stdin.puts(input)
        stdin.close

        result = stdout.read

        stdout.close
        thread.join
      end

      result
    end
  end
end
