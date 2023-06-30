module Fido
module Adapter
module IDF
  class Parser
  
    include ParsesIDF
    include UsesSchema
    
    def initialize(idf_path = nil)
      mark_idf(idf_path) unless idf_path.nil?
    end

    # 
    # Attributes
    # 

    def marks
      @marks ||= Hash.new { |hsh, key| hsh[key] = [] }
    end
    
    def objects
      @objects ||= Hash.new do |outer, name|
        outer[name] = Hash.new do |inner, id|
          inner[id] = {}
        end
      end
    end
    
    #
    # Methods
    #
    
    def mark_idf(idf_path)
      reset
      @idf = idf_path
      File.open(idf_path) do |idf|j
        while (line = idf.gets)
          next unless object_open?(line)

          name = object_name_regex.match(line)[1]
          start = start_pos(line)
          
          until object_close?(line) || line.nil?
            line = idf.gets
          end
            
          @marks[name] << [ end_pos(line) - start, start ]
        end
      end
    end
    
    alias parse_idf mark_idf

    def fetch(object_name)
      return objects[object_name] if objects.key?(object_name)
      
      return unless marks.key?(object_name)
      
      marks[object_name].inject({}) do |memo, location|
        object_string = File.read(@idf, *location)
        parsed_name, object_hash = parse_object(object_string)

        raise "#{parsed_name} != #{object_name}" if parsed_name != object_name

        objects[object_name] = memo.merge(object_hash)
      end
    end

    alias [] fetch

    def start_pos(line)
      start = line.index(/\w/)
      @idf.pos - (line.length - start)
    end
    
    def end_pos(line)
      obj_strs = line.partition(/!/).first.scan(/[^;!]+;/)
      line_object_end = obj_strs.first.index(/;/)
      @idf.pos - line.length + line_object_end + 1
    end
    
    def object_open?(line)
      object_name_regex.match? line
    end
    
    def object_close?(line)
      object_close_regex.match? line
    end
    
    def reset
      marks.clear
      objects.clear
    end
  end
end
end
end