require_relative "../../dottie"

module Dottie::Cli
  class DirectoryNotFound < StandardError
    attr_reader :directory

    def initialize(message, directory)
      super(message)
      @directory = directory
    end

    class << self
      def for(directory)
        new("Directory not found: '#{directory}'", directory)
      end

      private :new
    end
  end
end
