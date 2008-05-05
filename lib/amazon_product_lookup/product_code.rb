module AmazonProductLookup
  class ProductCode
    attr_accessor :code_type
    
    def to_s
      @code
    end
    
    # a proxy method to the various product code validators
    def self.validate!(code)
      code = ProductCode.normalize(code)
      case code.size
      when 10
        Isbn10.validate!(code)
      when 12
        Upc.validate!(code)
      when 13
        Ean.validate!(code)
      else
        raise InvalidProductCode, "code size is not valid (or not supported)"
      end
    end

    def initialize(code)
      ProductCode.validate!(code)
      @code = ProductCode.normalize(code)
      @code_type = case code.size
      when 10
        :isbn10
      when 12
        :upc
      when 13
        :ean
      end
    end


    def self.validate(code)
      self.validate!(code)
      true
    rescue
      false
    end
    
    # reject everything that cannot possibly be part of a product code
    def self.normalize(code)
      code.upcase.gsub(/[^0-9X]/, '')
    end
  end
  
  class InvalidProductCode < RuntimeError
  end
  
end