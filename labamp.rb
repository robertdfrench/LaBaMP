module Labamp
  class Program
    attr_reader :c_source_code
    attr_reader :name

    def compile
      @c_source_code = "#include <stdio.h>\n\nint main(int argc, char** argv) {\n\tprintf(\"Hello!\\n\");\n\treturn 0;\n}"
    end

    def initialize(name)
      @name = name.to_s
    end

    def double
      Type.by_name(:double)
    end

    def list(length, type)
      raise(Error::LabampTypeError, "Probably you want to use like a positive integer for your list length") unless length.is_a? Integer
      raise(Error::LabampTypeError, "Just between you and me, I think you're trying to make a negative length list here. I'm not down with that. I'm a pacifist") unless length > 0
      raise(Error::LabampTypeError, "If you want a list, you gotta tell me what type the elements are") unless type.is_a? Type

      
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


  class Type
    attr_reader :name
    
    def initialize(name)
      @name = name
    end

    def self.by_name(name)
      @@type_dictionary[name] = Type.new(name) if @@type_dictionary[name].nil?
      @@type_dictionary[name]
    end

    @@type_dictionary = {}
  end

  class ComposableType 


  end
end
