require "open3"
require "timeout"

module Dottie
  class Runner
    class << self
      def for(command, timeout)
        RUNNERS[command] ||= self.new(command, timeout)
      end

      RUNNERS = {}
    end

    def initialize(command, timeout)
      @command = command
      @timeout = timeout
    end

    def run(input, directory, env = {})
      options = { chdir: directory }

      Open3.popen2e(env, @command, options) do |stdin, stdout_and_stderr, thread|
        Timeout.timeout(@timeout) do
          stdin.puts(input)
          stdin.close

          stdout_and_stderr.read
        end
      rescue
        # try to stop the process with SIGTERM, but kill it if it doesn't exit
        # when asked nicely
        begin
          Timeout.timeout(@timeout) do
            Process.kill("TERM", thread.pid)
            thread.join
          end
        rescue Timeout::Error
          Process.kill("KILL", thread.pid)
          thread.join
        end

        raise
      end
    end
  end
end
