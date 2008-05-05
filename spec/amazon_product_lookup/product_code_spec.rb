require File.dirname(__FILE__) + '/../spec_helper'

describe AmazonProductLookup::ProductCode, "normalize" do
  it "should eliminate everything exept numeric digits and X" do
    AmazonProductLookup::ProductCode.normalize("123!\"§$%/()=?X456").should == "123X456"
  end
end

describe AmazonProductLookup::ProductCode, "validate!" do
  it "should call ISBN10.validate! if size == 10" do
    AmazonProductLookup::Isbn10.should_receive(:validate!).with("1234567890").and_return(true)
    AmazonProductLookup::ProductCode.validate!("1234567890").should be_true
  end
  it "should call EAN.validate! if size == 13" do
    AmazonProductLookup::Ean.should_receive(:validate!).with("1234567890123").and_return(true)
    AmazonProductLookup::ProductCode.validate!("1234567890123").should be_true
  end

  it "should call EAN.validate! if size == 13" do
    AmazonProductLookup::Ean.should_receive(:validate!).with("1234567890123").and_return(true)
    AmazonProductLookup::ProductCode.validate!("1234567890123").should be_true
  end
  it "should raise InvalidProductCode if size is too small" do
    lambda {
      AmazonProductLookup::ProductCode.validate!("123456789").should
    }.should raise_error(AmazonProductLookup::InvalidProductCode, "code size is not valid (or not supported)")    
  end
  it "should raise InvalidProductCode if size is too big" do
    lambda {
      AmazonProductLookup::ProductCode.validate!("12345678901234").should
    }.should raise_error(AmazonProductLookup::InvalidProductCode, "code size is not valid (or not supported)")    
  end  
end

describe AmazonProductLookup::ProductCode, "validate" do
  it "should not raise error with invalid code" do
    lambda {
      AmazonProductLookup::ProductCode.validate("12345678901234")
    }.should_not raise_error(AmazonProductLookup::InvalidProductCode)
  end
  
  it "should return false if invalid code is given" do
    AmazonProductLookup::ProductCode.stub!(:validate!).and_raise(AmazonProductLookup::InvalidProductCode)
    AmazonProductLookup::ProductCode.validate("12345678901234").should be_false
  end
  it "should return true if valid code is given" do
    AmazonProductLookup::ProductCode.stub!(:validate!).and_return(true)
    AmazonProductLookup::ProductCode.validate("12345678901234").should be_true
  end
end

describe AmazonProductLookup::ProductCode, "initialize" do
  it "should make correct UPC code" do
    pc = AmazonProductLookup::ProductCode.new("036000291452")
    pc.code_type.should == :upc
  end
  it "should make correct ISBN10 code" do
    pc = AmazonProductLookup::ProductCode.new("3423207493")
    pc.code_type.should == :isbn10
  end
  it "should save code" do
    pc = AmazonProductLookup::ProductCode.new("036000291452")
    pc.to_s == "036000291452"
  end
end