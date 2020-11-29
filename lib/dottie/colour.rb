module Dottie::Colour
  def colour(string)
    ColourableString.new(string)
  end

  class ColourableString
    def initialize(string)
      @string = string
    end

    def bold; colour(1) end
    def dim; colour(2) end
    def red; colour(31) end
    def green; colour(32) end
    def yellow; colour(33) end
    def cyan; colour(36) end

    def to_s; @string end

    private

    def colour(code)
      @string = "\e[#{code}m#{@string}\e[0m"

      self
    end
  end

  private_constant :ColourableString
end
