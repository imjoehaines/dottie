module Dottie::Command
  class << self
    def for(extension)
      case extension
      when ".phpt" then "php"
      when ".rubyt" then "ruby"
      else raise "Unknown file type '#{extension}'!"
      end
    end
  end
end
