module ConditionChecker
  class Condition
    attr_reader :name, :conditional, :result

    def initialize(name, conditional)
      @name = name.to_s
      @conditional = conditional
      @result = nil
    end

    def call(object)
      @result = Result.new(name: name, result: conditional.call(object))
    end

    def success?
      !!@result&.result
    end

    def fail?
      !@result&.result
    end

    def to_s
      "#{self.class}(name: #{name.inspect}, result: #{result})"
    end
  end
end
