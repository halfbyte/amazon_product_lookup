$:.unshift File.dirname(__FILE__)

require "amazon_product_lookup/product_finder"
require "amazon_product_lookup/product_code"
require "amazon_product_lookup/isbn10"
require "amazon_product_lookup/upc"
require "amazon_product_lookup/ean"

require "ECS"

module AmazonProductLookup
  
  @@ecs_setup_done = false
  
  def self.setup_ecs(access_key, cache_directory = '/tmp/ecs_cache', time_file = '/tmp/ecs_time_file')
    ECS.access_key_id = access_key
    ECS.cache_directory = cache_directory
    ECS::TimeManagement.time_file = time_file
    @@ecs_setup_done = true
  rescue
    false
  end
  #
  # easiest shortcut
  # 
  def self.lookup(code)
    ProductFinder.find(code)
  end
  
end