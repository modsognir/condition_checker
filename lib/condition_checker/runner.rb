module ConditionChecker
  class Runner
    attr_reader :object

    def initialize(object, conditions, checks)
      @object = object
      @checks = checks
      @run = false
    end

    def run
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

    def success?
      successes.all?
    end

    def fail?
      fails.any?
    end

    def [](name)
      checks.find { |check| check.name.to_s == name.to_s }
    end
    alias find []
  end
end
