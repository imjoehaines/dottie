require_relative "formatter/pretty"

module Dottie::Formatter
  class << self
    def for(type)
      case type
      when :pretty then Dottie::Formatter::Pretty.new
      else raise "Unknown formatter type '#{type}'!"
      end
    end
  end
end
