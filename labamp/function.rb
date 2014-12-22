module Labamp
  class Function
    attr_reader :name
    attr_reader :return_type

    def initialize(name, return_type, params_hash)
      @name = name
      @return_type = return_type
      @params_hash = params_hash
    end

    def signature
      params = @params_hash.collect do |pname, ptype|
        ptype.declaration_template.gsub(/VARNAME/, pname.to_s)
      end

      "#{return_type.to_s} #{name}(#{params.join(", ")})"
    end

    def to_s
      signature
    end
  end
end
