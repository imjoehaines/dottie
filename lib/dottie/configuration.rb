require "etc"
require_relative "./formatter/pretty"

module Dottie
  class Configuration
    attr_accessor :formatter
    attr_accessor :max_threads
    attr_accessor :test_directories

    def initialize
      @formatter = Dottie::Formatter::Pretty.new(self)
      @max_threads = Etc.nprocessors
      @test_directories = ["tests"]
    end
  end
end
