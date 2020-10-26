require "open3"

module Dottie
  class Runner
    class << self
      def for(type)
        RUNNERS[type] ||= self.new(type.command)
      end

      RUNNERS = {}
    end

    def initialize(command)
      @command = command
    end

    def run(input, env = {})
      result = nil

      Open3.popen2e(env, @command) do |stdin, stdout, thread|
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
