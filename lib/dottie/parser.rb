module Dottie::Parser
  class << self
    def parse(path)
      sections = {}

      File.open(path) do |file|
        section = nil

        file.each_line do |line|
          matches = /^--([A-Z]+)--$/.match(line)

          if matches
            section = matches[1].downcase.to_sym

            raise "Duplicate '--#{matches[1]}--' section found" if sections.has_key?(section)

            sections[section] = ""

            next
          end

          raise "Must begin a test file with --TEST--" unless section

          sections[section] += line
        end
      end

      sections
    end

    private

    def validate(sections)
      raise "oh no #{sections}"
    end
  end
end
