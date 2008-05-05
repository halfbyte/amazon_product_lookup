module AmazonProductLookup
  class Ean
    def self.validate!(code)
      code = self.normalize(code)
      raise(InvalidProductCode, "EAN must be 13 characters long, got #{code.size} characters") unless code.size == 13
      raise(InvalidProductCode, "EAN checksum is wrong") unless self.validate_checksum(code)
      true
    end
    
    def self.normalize(code)
      code.gsub(/[^0-9]/, "")
    end
    
    def self.validate_checksum(code)
      return false unless code.size == 13
      code[12,1] == self.checksum(code)
    end
    
    
    def self.checksum(code)
      return false unless code.size == 13
      sum = 0
      11.downto(0) do |i|
        digit = code[i,1].to_i
        sum += (i % 2 == 0) ? digit : digit * 3
      end
      ((10 - (sum % 10)) % 10).to_s
    end
    
  end
end