require 'condition_checker/condition'
require 'condition_checker/check'
require 'condition_checker/runner'

module ConditionChecker
  module Mixin
    def conditions
      @conditions ||= {}
    end

    def checks
      @checks ||= {}
    end

    def condition(name, checker)
      conditions[name.to_s] = Condition.new(name, checker)
    end

    def check(name, conditions:)
      check_conditions = conditions.map { |condition_name|
        @conditions[condition_name.to_s] || raise(Error, "Condition '#{condition_name}' not found")
      }
      checks[name.to_s] = Check.new(name, check_conditions)
    end

    def for(object)
      ConditionChecker::Runner.new(object, conditions.values, checks.values)
    end
  end
end
