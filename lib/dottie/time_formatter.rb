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

        if string == "" || minutes == 0
          string << milliseconds.to_s

          if seconds == 0
            microseconds = (nanoseconds / 1_000) % 1_000

            string << sprintf(".%03d", microseconds)
          end

          string << "ms"
        end

        string.rstrip
      end
    end
  end
end
