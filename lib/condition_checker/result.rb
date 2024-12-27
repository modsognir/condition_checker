module ConditionChecker
  class Result
    attr_reader :name, :conditional, :value

    def initialize(name:, value:)
      @name = name.to_s
      @value = value
    end

    def success?
      !!@value
    end

    def fail?
      @value == false
    end

    def ==(other)
      name == other.name && value == other.value
    end
  end
end
