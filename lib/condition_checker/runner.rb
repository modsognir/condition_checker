module ConditionChecker
  class Runner
    attr_reader :context

    def initialize(context, conditions, checks)
      @context = context
      @checks = checks
      @run = false
    end

    def run
      @run = true
      @checks.each { |check| check.call(context) }
      self
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
      successes.size == checks.size
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
