require "etc"
require_relative "./formatter/pretty"

module Dottie
  class Configuration
    attr_accessor :formatter
    attr_accessor :max_threads

    def initialize
      @formatter = Dottie::Formatter::Pretty.new
      @max_threads = Etc.nprocessors
    end
  end
end
