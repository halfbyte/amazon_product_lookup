require File.dirname(__FILE__) + '/../spec_helper'

describe AmazonProductLookup::Ean, "checksum" do
  it "should return false if size is wrong" do
    AmazonProductLookup::Ean.checksum("1212").should be_false
  end
  it "should return 1 for 5449000096241" do
    # Vanilla Coke (taken from  http://de.wikipedia.org/wiki/European_Article_Number)
    AmazonProductLookup::Ean.checksum("5449000096241").should == "1"
  end
end

describe AmazonProductLookup::Ean, "validate checksum" do
  it "should return false if size is wrong" do
    AmazonProductLookup::Ean.validate_checksum("1212").should be_false
  end
  it "should return false for 5449000096242" do
    AmazonProductLookup::Ean.validate_checksum("5449000096242").should be_false
  end
  it "should return true for 5449000096241" do
    AmazonProductLookup::Ean.validate_checksum("5449000096241").should be_true
  end
end
describe AmazonProductLookup::Ean, "normalize" do
  it "should eliminate everything exept numeric digits" do
    AmazonProductLookup::Ean.normalize("123!\"§$%/()=?X456").should == "123456"
  end
end
 
describe AmazonProductLookup::Ean, "validate!" do
  it "should accept 5449000096241" do
    lambda {
      AmazonProductLookup::Ean.validate!("5449000096241")
    }.should_not raise_error(AmazonProductLookup::InvalidProductCode)
  end
  it "should not accept 5449000096242 for wrong checksum" do
    lambda {
      AmazonProductLookup::Ean.validate!("5449000096242")
    }.should raise_error(AmazonProductLookup::InvalidProductCode, "EAN checksum is wrong")
  end
  it "should not accept 54490000 for wrong length" do
    lambda {
      AmazonProductLookup::Ean.validate!("54490000")
    }.should raise_error(AmazonProductLookup::InvalidProductCode, "EAN must be 13 characters long, got #{"54490000".size} characters")
  end
end