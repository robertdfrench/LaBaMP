module Labamp
  class Variable
    def initialize(scope, name, type)
      @scope = scope
      @name = name
      @type = type
      # Needs to import functions from type somehow
    end

    def method_missing(name, *args, &block)
      raise(Error::LabampTypeError, "The type '#{@type.to_s}' does not respond to '#{name}'. Please hang up and try your call again") unless @type.respond_to? name
      expr = UnaryExpression.new
      expr.type = @type.send(name, *args)
      expr.left = self
      expr.op = name
      expr.scope = @scope
    end
  end
end
