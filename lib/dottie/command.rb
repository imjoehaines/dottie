module Dottie::Command
  class << self
    COMMANDS = {
      ".rbt" => "ruby",
    }

    def for(extension)
      if COMMANDS.key?(extension)
        COMMANDS[extension]
      else
        # if we don't know what the command is, we guess by removing a leading
        # "." and trailing "t", e.g. '.rubyt' => 'ruby', '.phpt' => 'php'
        register(extension, extension.delete_prefix(".").delete_suffix("t"))
      end
    end

    def register(extension, command)
      COMMANDS[extension] = command
    end
  end
end
