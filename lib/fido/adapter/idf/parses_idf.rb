module Fido
module Adapter
module IDF
  module ParsesIDF
    
    def object_name_regex
      @object_name_regex ||= /^\s*([A-Z][A-Za-z]+(:[A-Z][A-Za-z]+)*)\s*,/
    end
    
    def object_close_regex
      @object_close_regex ||= /^[^!]*;\s*(!.*)?/
    end

    def parse_object(str)
      (name, comment), *values = decompose_object(str)
      begin
        validate(name, values)
      rescue ArgumentError => e
        msg = "Invalid #{object_name}:\n#{str}"
        puts msg
        puts e.message
        puts e.backtrace
        exit(1)
      end
      {object_name => compile_object(object_name, values)}
    end

    def decompose_object(str);end
    
    def compile_object(name, values);end

    def parse_line_values(line);end
    
    def parse_comment(comment); end
  end
end
end
end