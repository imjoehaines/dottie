require "open3"

module Dottie
  class Runner
    def run(command, input, env = {})
      result = nil

      Open3.popen2e(env, command) do |stdin, stdout, thread|
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
