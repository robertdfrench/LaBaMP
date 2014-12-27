module Labamp
  class Variable
    def initialize(scope, name, type)
      @scope = scope
      @name = name
      @type = type
      # Needs to import functions from type somehow
    end
  end
end
