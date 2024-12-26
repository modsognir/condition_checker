module ConditionChecker
  class Runner
    attr_reader :object, :conditions

    def initialize(object, conditions, checks)
      @object = object
      @conditions = conditions
      @checks = checks
      @run = false
    end

    def run
      conditions.each { |condition| condition.call(object) }
      @checks.each { |check| check.call(object) }
      @run = true
      @checks
    end

    def checks
      run if !@run
      @checks
    end

    def successes
      checks.select(&:success?)
    end

    def fails
      checks.select(&:fail?)
    end
  end
end
