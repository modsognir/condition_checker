require 'condition_checker/condition'
require 'condition_checker/check'
require 'condition_checker/runner'
require 'condition_checker/method_condition'

module ConditionChecker
  module Mixin
    def self.included(base)
      base.extend(ClassMethods)
      base.attr_accessor :context
    end

    module ClassMethods
      attr_accessor :context

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
          @conditions[condition_name.to_s] ||= MethodCondition.new(condition_name, self)
        }
        checks[name.to_s] = Check.new(name, check_conditions)
      end

      def for(object)
        ConditionChecker::Runner.new(object, conditions.values, checks.values)
      end
    end
  end
end
