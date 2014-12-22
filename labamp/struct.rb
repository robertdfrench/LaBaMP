module Labamp
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
end
