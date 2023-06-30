module Fido
module IDF
  class Property

    def initialize(name, type, extensible: false, defualt: nil)
      
      case type.to_s.strip
      when /^(string|integer|float|boolean|time|date)$/
        init_base
      when /object_list/
      when /reference/
      end
      
    end
    
    def referenced_object

    end
  end
end
end