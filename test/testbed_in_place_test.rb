require 'test/unit'
require File.dirname(__FILE__) + '/../lib/testbed'
require File.dirname(__FILE__) + '/test_helper'

class TestbedInPlaceTest < Test::Unit::TestCase
  
  testbed "this should work" do |input|
    input * 2
  end
  verify_that(1).returns(2)
  verify_that(0).returns(0)
  
end