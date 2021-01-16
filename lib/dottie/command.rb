module Dottie::Command
  class << self
    COMMANDS = {
      ".phpt" => "php",
      ".rubyt" => "ruby",
    }

    def for(extension)
      raise "Unknown file type '#{extension}'!" unless COMMANDS.key?(extension)

      COMMANDS[extension]
    end

    def register(extension, command)
      COMMANDS[extension] = command
    end
  end
end
