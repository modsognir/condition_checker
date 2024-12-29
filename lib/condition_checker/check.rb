module ConditionChecker
  class Check
    attr_reader :name, :conditions, :result

    def initialize(name, conditions)
      @name = name.to_s
      @conditions = conditions
      @result = nil
    end

    def call(context)
      @result = conditions.map { |condition| condition.call(context) }
    end

    def successes
      @result.select(&:success?)
    end

    def fails
      @result.select(&:fail?)
    end

    def success?
      @result.all?(&:success?)
    end

    def fail?
      @result.any?(&:fail?)
    end

    def to_s
      "#{self.class}(name: #{name.inspect}, result: #{result.inspect}, conditions: #{conditions.inspect})"
    end
  end
end
