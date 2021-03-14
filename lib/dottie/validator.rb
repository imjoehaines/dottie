module Dottie
  class Validator
    def validate(sections)
      raise "Test files must have a 'TEST' section" unless sections[:test]
      raise "Test files must have a 'FILE' section" unless sections[:file]

      if sections[:expect].nil? && sections[:expectf].nil? && sections[:expectregex].nil?
        raise "Test files must have an 'EXPECT', 'EXPECTF' or 'EXPECTREGEX' section"
      end

      if sections[:expect] && sections[:expectf]
        raise "Test files cannot have both 'EXPECT' and 'EXPECTF' sections"
      end

      if sections[:expect] && sections[:expectregex]
        raise "Test files cannot have both 'EXPECT' and 'EXPECTREGEX' sections"
      end

      if sections[:expectf] && sections[:expectregex]
        raise "Test files cannot have both 'EXPECTF' and 'EXPECTREGEX' sections"
      end

      true
    end
  end
end
