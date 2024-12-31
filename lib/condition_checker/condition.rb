module ConditionChecker
  class Condition
    attr_reader :name, :conditional, :result

    def initialize(name, conditional)
      @name = name.to_s
      @conditional = conditional
      @result = nil
    end

    def call(context)
      @result = Result.new(name: name, value: call_conditional(context))
    rescue => e
      @result = Result.new(name: name, value: false, error: e)
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

    def call_conditional(context)
      return conditional.call(context) if conditional.is_a?(Class)

      (conditional.arity == 1) ? conditional.call(context) : conditional.call
    end

    def to_s
      "#{self.class}(name: #{name.inspect}, result: #{result})"
    end
  end
end
