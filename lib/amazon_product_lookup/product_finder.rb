module AmazonProductLookup
  class ProductFinder
    def self.find(code)
      ProductFinder.new(code).find
    end
    
    def initialize(code)
      ProductCode.validate!(code)
      @product_code = ProductCode.normalize(code)
    end
        
  end  
end