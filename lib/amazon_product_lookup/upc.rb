module AmazonProductLookup
  class Upc < ProductCode
    def self.validate!(code)
      code = self.normalize(code)
      raise(InvalidProductCode, "UPC must be 12 characters long, got #{code.size} characters") unless code.size == 12
      raise(InvalidProductCode, "UPC checksum is wrong") unless self.validate_checksum(code)
      true
    end

    def self.normalize(code)
      code.gsub(/[^0-9]/, "")
    end
        
    def self.validate_checksum(code)
      return false unless code.size == 12
      code[11,1] == self.checksum(code)
    end
    
    def self.checksum(code)
      return false unless code.size == 12
      sum = 0
      0.upto(10) do |i|
        digit = code[i,1].to_i
        sum += (i % 2 == 0) ? digit * 3 : digit
      end
      ((10 - (sum % 10)) % 10).to_s
    end
    
  end
end