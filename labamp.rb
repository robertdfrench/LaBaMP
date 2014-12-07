module Labamp
  class Program
    attr_reader :c_source_code
    attr_reader :name
    attr_accessor :structs

    def compile
      @c_source_code = "#include <stdio.h>\n\nint main(int argc, char** argv) {\n\tprintf(\"Hello!\\n\");\n\treturn 0;\n}"
    end

    def initialize(name)
      @name = name.to_s
      @structs = []
    end

    def double
      Type.by_name(:double)
    end

    def list(type, length)
      raise(Error::LabampTypeError, "Probably you want to use like a positive integer for your list length") unless length.is_a? Integer
      raise(Error::LabampTypeError, "Just between you and me, I think you're trying to make a negative length list here. I'm not down with that. I'm a pacifist") unless length > 0
      raise(Error::LabampTypeError, "If you want a list, you gotta tell me what type the elements are") unless type.is_a? Type

      
      Type.list_of(type, length)
    end

    def struct(name, fields_hash)
      structs << Struct.new(name, fields_hash)
    end
  end

  def program(name, &program_block)
    p = Program.new(name)
    p.instance_eval &program_block
    p.compile
    puts p.c_source_code
  end

  module Error
    class LabampTypeError < StandardError
    end
  end

  class Struct
    attr_reader :name
    attr_reader :fields_hash

    def initialize(name, fields_hash)
      @name = name
      @fields_hash = fields_hash
    end

    def to_s
      sections = []
      sections << "typedef struct #{name} {\n\t" 
      fields_hash.each_pair do |fieldtype,fieldname|
        "\t#{fieldtype} #{fieldname};\n"
      end
      sections << "} #{name};"
    end
  end

  class Type
    attr_reader :name
    
    def initialize(name)
      @name = name
    end

    def self.by_name(name)
      @@type_dictionary[name] = Type.new(name) if @@type_dictionary[name].nil?
      @@type_dictionary[name]
    end

    def self.list_of(type, length)
      derived_name = "list(#{type},#{length})"
      by_name(derived_name)
    end

    @@type_dictionary = {}
  end

  class ComposableType 


  end
end
