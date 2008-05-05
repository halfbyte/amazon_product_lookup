require File.dirname(__FILE__) + '/../spec_helper'

describe AmazonProductLookup::Upc, "checksum" do
  it "should return false if size is wrong" do
    AmazonProductLookup::Upc.checksum("1212").should be_false
  end
  it "should return 2 for 03600029145x" do
    # this example is from http://en.wikipedia.org/wiki/Universal_Product_Code
    AmazonProductLookup::Upc.checksum("03600029145x").should == "2"
  end
end

describe AmazonProductLookup::Upc, "validate checksum" do
  it "should return false if size is wrong" do
    AmazonProductLookup::Upc.validate_checksum("1212").should be_false
  end
  it "should return false for 036000291451" do
    AmazonProductLookup::Upc.validate_checksum("036000291451").should be_false
  end
  it "should return true for 036000291452" do
    AmazonProductLookup::Upc.validate_checksum("036000291452").should be_true
  end
end

describe AmazonProductLookup::Upc, "normalize" do
  it "should eliminate everything exept numeric digits" do
    AmazonProductLookup::Upc.normalize("123!\"§$%/()=?456").should == "123456"
  end
end

describe AmazonProductLookup::Upc, "validate!" do
  it "should accept 036000291452" do
    lambda {
      AmazonProductLookup::Upc.validate!("036000291452")
    }.should_not raise_error(AmazonProductLookup::InvalidProductCode)
  end
  it "should not accept 036000291451 for wrong checksum" do
    lambda {
      AmazonProductLookup::Upc.validate!("036000291451")
    }.should raise_error(AmazonProductLookup::InvalidProductCode, "UPC checksum is wrong")
  end
  it "should not accept 0360002914 for wrong length" do
    lambda {
      AmazonProductLookup::Upc.validate!("0360002914")
    }.should raise_error(AmazonProductLookup::InvalidProductCode, "UPC must be 12 characters long, got #{"0360002914".size} characters")
  end
end