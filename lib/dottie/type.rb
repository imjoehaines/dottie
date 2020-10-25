require_relative "type/php"
require_relative "type/ruby"

module Dottie
  module Type
    def self.for(extension)
      case extension
        when ".phpt" then Dottie::Type::Php.new
        when ".rubyt" then Dottie::Type::Ruby.new
        else raise "Unknown file type '#{extension}'!"
      end
    end
end
