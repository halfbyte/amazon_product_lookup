require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.rubyforge.org/
describe AmazonProductLookup, "setup_ecs" do
  it "should return true" do
    AmazonProductLookup.setup_ecs("foobar").should be_true
  end
  it "should retrun false if anything raises an exception" do
    ECS.stub!(:access_key_id=).and_raise(RuntimeError)
    AmazonProductLookup.setup_ecs("foobar").should be_false
  end
  it "should setup ecs" do
    ECS.should_receive(:access_key_id=).with("access_key")
    ECS.should_receive(:cache_directory=).with("cachedir")
    ECS::TimeManagement.should_receive(:time_file=).with("timefile")
    AmazonProductLookup.setup_ecs("access_key", "cachedir", "timefile")
  end
end

describe AmazonProductLookup, "find_product" do
  it "should call ProductFinder.find" do
    AmazonProductLookup::ProductFinder.should_receive(:find).and_return(nil)
    AmazonProductLookup.lookup("292992")
  end
end