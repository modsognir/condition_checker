module ConditionChecker
  class Condition
    attr_reader :name, :conditional, :result

    def initialize(name, conditional)
      @name = name.to_s
      @conditional = conditional
      @result = nil
    end

    def call(object)
      @result = Result.new(name: name, value: call_conditional(object))
    end

    def success?
      !!value
    end

    def fail?
      !value
    end

    def value
      @result&.value
    end

    def call_conditional(object)
      return conditional.call(object) if conditional.is_a?(Class)

      conditional.arity == 1 ? conditional.call(object) : conditional.call
    end

    def to_s
      "#{self.class}(name: #{name.inspect}, result: #{result})"
    end
  end
end
