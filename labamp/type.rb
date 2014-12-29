module Labamp
  class Type
    attr_reader :name
    attr_accessor :declaration_template
    attr_accessor :associated_struct
    attr_accessor :eigenmodule

    def initialize(name)
      @name = name
      @declaration_template = "#{name.to_s} VARNAME"
    end

    def to_s
      name
    end
  end
end
