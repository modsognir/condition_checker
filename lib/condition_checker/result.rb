module ConditionChecker
  class Result
    attr_reader :name, :conditional, :result

    def initialize(name:, result:)
      @name = name.to_s
      @result = result
    end

    def success?
      !!@result
    end

    def fail?
      @result == false
    end

    def ==(other)
      name == other.name && result == other.result
    end
  end
end
