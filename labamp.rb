require_relative "labamp/error.rb"
require_relative "labamp/function.rb"
require_relative "labamp/program.rb"
require_relative "labamp/struct.rb"
require_relative "labamp/type.rb"
require_relative "labamp/variable.rb"
require_relative "labamp/expression.rb"
require_relative "labamp/type_manager.rb"
require_relative "labamp/type_helpers.rb"
require_relative "labamp/type_helpers/method_definer.rb"
module Labamp

  def program(name, &program_block)
    p = Program.new(name)
    p.headers << "stdio.h"
    p.instance_eval &program_block
    p.compile
    puts p.c_source_code
  end

  def self.log(msg)
    puts "[LaBaMP] #{msg}"
  end
end
