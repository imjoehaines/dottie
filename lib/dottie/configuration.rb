require "etc"
require_relative "./formatter/pretty"

module Dottie
  class Configuration
    attr_accessor :formatter
    attr_accessor :max_threads
    attr_accessor :test_directories
    attr_accessor :timeout

    def initialize
      @formatter = Dottie::Formatter::Pretty.new(self)
      @max_threads = Etc.nprocessors
      @test_directories = ["tests"]
      @timeout = 5
    end
  end
end
