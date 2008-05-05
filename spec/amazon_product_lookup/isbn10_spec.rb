require File.dirname(__FILE__) + '/../spec_helper'

describe AmazonProductLookup::Isbn10, "checksum" do
  it "should return false if size is wrong" do
    AmazonProductLookup::Isbn10.checksum("1212").should be_false
  end
  it "should return 3 for 342320749x" do
    # this example is Matt Ruff "Fool on the hill", dtv-Taschenbuecher
    AmazonProductLookup::Isbn10.checksum("342320749x").should == "3"
  end
end

describe AmazonProductLookup::Isbn10, "validate checksum" do
  it "should return false if size is wrong" do
    AmazonProductLookup::Isbn10.validate_checksum("1212").should be_false
  end
  it "should return false for 342320749x" do
    AmazonProductLookup::Isbn10.validate_checksum("342320749x").should be_false
  end
  it "should return true for 3423207493" do
    AmazonProductLookup::Isbn10.validate_checksum("3423207493").should be_true
  end
end

describe AmazonProductLookup::Isbn10, "normalize" do
  it "should eliminate everything exept numeric digits and X" do
    AmazonProductLookup::Isbn10.normalize("123!\"§$%/()=?X456").should == "123X456"
  end
end
# 
describe AmazonProductLookup::Isbn10, "validate!" do
  it "should accept 3423207493" do
    lambda {
      AmazonProductLookup::Isbn10.validate!("3423207493")
    }.should_not raise_error(AmazonProductLookup::InvalidProductCode)
  end
  it "should not accept 3423207494 for wrong checksum" do
    lambda {
      AmazonProductLookup::Isbn10.validate!("3423207494")
    }.should raise_error(AmazonProductLookup::InvalidProductCode, "ISBN-10 checksum is wrong")
  end
  it "should not accept 0360002914 for wrong length" do
    lambda {
      AmazonProductLookup::Isbn10.validate!("00002914")
    }.should raise_error(AmazonProductLookup::InvalidProductCode, "ISBN-10 must be 10 characters long, got #{"00002914".size} characters")
  end
end