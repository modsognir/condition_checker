module ConditionChecker
  class Check
    attr_reader :name, :conditions, :result

    def initialize(name, conditions)
      @name = name.to_s
      @conditions = conditions
      @result = nil
    end

    def call(object)
      @result = conditions.map { |condition| condition.call(object) }
    end

    def successes
      Array(@result).select(&:success?)
    end

    def fails
      Array(@result).reject(&:success?)
    end

    def success?
      successes.size == conditions.size
    end

    def fail?
      fails.size > 0
    end

    def to_s
      "#{self.class}(name: #{name.inspect}, result: #{result.inspect}, conditions: #{conditions.inspect})"
    end
  end
end
