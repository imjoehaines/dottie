require "open3"

module Dottie
  class Runner
    class << self
      def for(command)
        RUNNERS[command] ||= self.new(command)
      end

      RUNNERS = {}
    end

    def initialize(command)
      @command = command
    end

    def run(input, directory, env = {})
      result, status = Open3.capture2e(env, @command, {
        chdir: directory,
        stdin_data: input
      })

      result
    end
  end
end
