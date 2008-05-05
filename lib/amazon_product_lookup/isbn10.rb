module AmazonProductLookup
  class Isbn10 < ProductCode
    def self.validate!(code)
      code = self.normalize(code)
      raise(InvalidProductCode, "ISBN-10 must be 10 characters long, got #{code.size} characters") unless code.size == 10
      raise(InvalidProductCode, "ISBN-10 checksum is wrong") unless self.validate_checksum(code)
      true
    end
    
    def self.validate_checksum(code)
      return false unless code.size == 10
      code[9,1] == self.checksum(code)
    end
    
    def self.checksum(code)
      return false unless code.size == 10
      sum = 0
      0.upto(8) do |i|
        digit = code[i,1].to_i
        sum += digit * (i+1)
      end
      checksum = sum % 11
      checksum == 10 ? "X" : checksum.to_s
    end
    
  end
end