require_relative "formatter/pretty"
require_relative "formatter/simple"

module Dottie::Formatter
  class << self
    def for(type)
      case type
      when :pretty then Dottie::Formatter::Pretty
      when :simple then Dottie::Formatter::Simple
      else raise "Unknown formatter type '#{type}'!"
      end
    end
  end
end
