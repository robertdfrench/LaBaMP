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
end
