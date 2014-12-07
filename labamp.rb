module Labamp
  class Program
    attr_reader :c_source_code
    attr_reader :name
    attr_accessor :headers
    attr_accessor :structs
    attr_accessor :functions

    def compile
      @c_lines = []
      @headers.each {|h| @c_lines << "#include <#{h}>"}
      @structs.each {|s| @c_lines << s.to_s}
      @functions.each {|f| @c_lines << f.to_s + ";"}
      @c_source_code = @c_lines.join("\n")
    end

    def initialize(name)
      @name = name.to_s
      @structs = []
      @headers = []
      @functions = []
    end

    def boolean
      Type.by_name :boolean
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
      s = Struct.new(name, fields_hash)
      structs << s
      stype = Type.for_struct s
      self.class.send(:define_method,name.to_sym) { return stype }
    end
  end

  def function(name, return_type, parameter_list, &block)
    return_type = Type.by_name return_type
    parameter_list.each_key do |k|
      parameter_list[k] = Type.by_name parameter_list[k]
    end
    f = Function.new(name, return_type, parameter_list)
    functions << f
  end

  def program(name, &program_block)
    p = Program.new(name)
    p.headers << "stdio.h"
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
      sections << "typedef struct #{name} {" 
      fields_hash.each_pair do |fieldname,fieldtype|
        sections << "\t#{fieldtype.declaration_template.gsub(/VARNAME/,fieldname.to_s)};"
      end
      sections << "} #{name};"
      sections.join("\n")
    end
  end

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

  def log(msg)
    puts "[LaBaMP] #{msg}"
  end
end
