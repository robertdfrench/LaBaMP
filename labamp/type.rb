module Labamp
  class Type
    attr_reader :name
    attr_accessor :declaration_template
    attr_accessor :associated_struct

    def initialize(name)
      @name = name
      @declaration_template = "#{name.to_s} VARNAME"
    end

    def self.by_name(type_or_name)
      name = type_or_name.to_s
      if @@type_dictionary[name].nil?
        log "Deriving new type #{name}"
        @@type_dictionary[name] = Type.new(name)
      end
      @@type_dictionary[name]
    end

    def self.list_of(type, length)
      derived_name = "list(#{type.to_s},#{length})"
      list_type = by_name(derived_name)
      list_type.declaration_template = "#{type.to_s} VARNAME[#{length}]"
      list_type
    end

    def self.for_struct(struct)
      struct_type = by_name(struct.name)
      struct_type.associated_struct = struct
      struct_type
    end

    @@type_dictionary = {}

    def to_s
      name
    end
  end
end
