require_relative "formatter/pretty"
require_relative "formatter/simple"

module Dottie::Formatter
  class << self
    def for(type)
      case type
      when :pretty then Dottie::Formatter::Pretty.new
      when :simple then Dottie::Formatter::Simple.new
      else raise "Unknown formatter type '#{type}'!"
      end
    end
  end
end
