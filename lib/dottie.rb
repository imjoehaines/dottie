module Dottie
  VERSION = "0.0.1".freeze

  class << self
    def banner(error: false)
      if error
        "❌ Dottie #{Dottie::VERSION} :("
      else
        "✨ Dottie #{Dottie::VERSION} :)"
      end
    end
  end
end
