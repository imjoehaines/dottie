module Dottie
  class TimeFormatter
    class << self
      def format(nanoseconds)
        minutes = nanoseconds / 60_000_000_000
        seconds = (nanoseconds / 1_000_000_000) % 60
        milliseconds = (nanoseconds / 1_000_000) % 1_000

        string = ""
        string << "#{minutes}m " if minutes > 0
        string << "#{seconds}s " if seconds > 0

        if string == ""
          microseconds = (nanoseconds / 1_000) % 1_000

          string << sprintf("%d.%03dms", milliseconds, microseconds)
        end

        string.rstrip
      end
    end
  end
end
