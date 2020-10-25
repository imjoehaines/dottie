require_relative "type/php"
require_relative "type/ruby"

module Dottie
  module Type
    def self.for(extension)
      case extension
        when ".phpt" then php_type
        when ".rubyt" then ruby_type
        else raise "Unknown file type '#{extension}'!"
      end
    end

    private

    def self.php_type
      @@php_type ||= Dottie::Type::Php.new
    end

    def self.ruby_type
      @@ruby_type ||= Dottie::Type::Ruby.new
    end
  end
end
