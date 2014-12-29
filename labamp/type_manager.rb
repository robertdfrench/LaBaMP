module Labamp
  class TypeManager
    attr_reader :type_dictionary
  
    def initialize(program)
      @program = program
      @type_dictionary = {}
      populate_type_dictionary_with_primitives
    end

    def exists?(type_or_name)
      !type_dictionary[type_or_name.to_s].nil?
    end

    def derive(name)
      Labamp.log "Deriving new type #{name}"
      t = Type.new(name)
      t.eigenmodule = Module.new
      t.extend t.eigenmodule
      t.eigenmodule.extend Labamp::TypeHelpers::MethodDefiner
      type_dictionary[name] = t
    end

    def by_name(type_or_name)
      name = type_or_name.to_s
      if type_or_name.is_a? Symbol
        sym = type_or_name
        return type_dictionary[sym] || type_dictionary[name]
      end
      type_dictionary[name]
    end

    def list_of(element_type, length=:unspecified)
      name = "list(#{element_type.to_s},#{length})"
      if !exists?(name)
        list_type = derive(name)
        list_type.eigenmodule.make_a_method :[] do |index| element_type end
        list_type.declaration_template = "#{element_type.to_s} VARNAME[#{length}]"
      end
      list_type.declaration_template = "#{element_type.to_s}* VARNAME" if length == :unspecified
      return self.by_name(name)
    end

    def for_struct(struct)
      if !exists?(struct.name)
        struct_type = derive(struct.name)
        struct_type.associated_struct = struct
        struct.fields_hash.each do |fieldname, fieldtype|
          struct_type.eigenmodule.make_a_method fieldname do fieldtype end
        end
      end
      return self.by_name(struct.name)
    end

    private
    def populate_type_dictionary_with_primitives
      derive(:double)
      derive(:boolean)
    end
  end
end
