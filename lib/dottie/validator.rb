module Dottie
  class Validator
    def validate(sections)
      raise "Test files must have a 'TEST' section" unless sections[:test]
      raise "Test files must have a 'FILE' section" unless sections[:file]

      unless sections[:expect] || sections[:expectf]
        raise "Test files must have either an 'EXPECT' or 'EXPECTF' section"
      end

      true
    end
  end
end
