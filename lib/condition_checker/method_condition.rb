module ConditionChecker
  class MethodCondition < Condition
    attr_reader :name, :host
    def initialize(method_name, host)
      @name = method_name.to_s
      @conditional = nil
      @result = nil
      @host = host.new
    end

    def call_conditional(context)
      host.context = context
      host.method(name).arity == 1 ? host.public_send(name, context) : host.public_send(name)
    end
  end
end
