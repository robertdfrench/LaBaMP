require_relative "labamp/error.rb"
require_relative "labamp/function.rb"
require_relative "labamp/program.rb"
require_relative "labamp/struct.rb"
require_relative "labamp/type.rb"
module Labamp

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

  def log(msg)
    puts "[LaBaMP] #{msg}"
  end
end
