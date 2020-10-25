module Dottie::Parser
  class << self
    def parse(file)
      sections = {}
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

      sections[:env] = parse_env(sections[:env]) if sections.has_key?(:env)

      sections
    end

    private

    def parse_env(env_string)
      env = {}

      env_string.each_line do |line|
        key, value = line.split("=")
        env[key] = value.chomp
      end

      env
    end
  end
end
