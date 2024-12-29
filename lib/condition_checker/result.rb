module ConditionChecker
  class Result
    attr_reader :name, :value, :error

    def initialize(name:, value:, error: nil)
      @name = name.to_s
      @value = value
      @error = error
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
