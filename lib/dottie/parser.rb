module Dottie
  class Parser
    def initialize(validator)
      @validator = validator
    end

    def parse(file)
      sections = {}
      section = nil

      file.each_line do |line|
        matches = /^--([A-Z_]+)--$/.match(line)

        if matches
          section = matches[1].downcase.to_sym

          raise "Duplicate '--#{matches[1]}--' section found" if sections.has_key?(section)

          sections[section] = ""

          next
        end

        raise "Must begin a test file with --TEST--" unless section

        sections[section] += line
      end

      sections[:directory] = File.dirname(file)
      sections[:env] = parse_env(sections[:env]) if sections.has_key?(:env)

      resolve_aliases!(sections)

      @validator.validate(sections)

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

    ALIASES = {
      :skip_if => :skipif,
      :expect_format => :expectf,
    }.freeze

    private_constant :ALIASES

    def resolve_aliases!(sections)
      ALIASES.each do |aliased_name, canonical_name|
        value = sections.delete(aliased_name)

        next if value.nil?

        sections[canonical_name] = value
      end
    end
  end
end
