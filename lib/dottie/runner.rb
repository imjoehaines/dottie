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

    def run(input, directory, env = {})
      result = nil

      Open3.popen2e(env, @command, { chdir: directory }) do |stdin, stdout, thread|
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
