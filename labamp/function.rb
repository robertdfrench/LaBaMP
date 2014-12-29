module Labamp
  class Function
    attr_reader :name
    attr_reader :return_type
    attr_reader :expressions

    def initialize(name, return_type, params_hash)
      @name = name
      @return_type = return_type
      @params_hash = params_hash
      @expressions = []
      summon_params
    end

    def signature
      params = @params_hash.collect do |pname, ptype|
        ptype.declaration_template.gsub(/VARNAME/, pname.to_s)
      end

      "#{return_type.to_s} #{name}(#{params.join(", ")})"
    end

    def to_s
      parts = []
      parts << signature + "{"
      expressions.each do |expr|
        parts << expr.to_s + ";"
      end
      parts << "}"
      parts.join("\n")
    end

    private
    def summon_params
      @params_hash.each do |name, type|
        v = Variable.new(self, name, type)
        self.class.class_eval do
          define_method(name) do v end
        end
      end
    end
  end
end
