require_relative "type/php"
require_relative "type/ruby"

module Dottie::Type
  class << self
    def for(extension)
      case extension
        when ".phpt" then php_type
        when ".rubyt" then ruby_type
        else raise "Unknown file type '#{extension}'!"
      end
    end

    private

    def php_type
      @@php_type ||= Dottie::Type::Php.new
    end

    def ruby_type
      @@ruby_type ||= Dottie::Type::Ruby.new
    end
  end
end
