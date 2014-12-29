module Labamp
  module TypeHelpers
    module MethodDefiner
      def make_a_method(name, &block)
        define_method(name, block)
      end
    end
  end
end
