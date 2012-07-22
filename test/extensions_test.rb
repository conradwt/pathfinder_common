require File.dirname(__FILE__) + '/../lib/testbed'
require 'test/unit' 
require File.dirname(__FILE__) + '/test_helper'
 
class User
end 
 
class ExtensionTest < Test::Unit::TestCase
  
  def test_create_an_alist
    actual = Hash.from_alist([["a", 1], ["b", 2]])
    assert_equal({"a" => 1, "b" => 2}, actual)
    assert_equal({}, Hash.from_alist([]))
    assert_equal(nil, nil)
  end
  
  testbed "create a hash from paired lists" do |a, b|
    Hash.from_lists(a, b)
  end
  verify_that([:a, :b, :c], [1, 2, 3]).returns({:a => 1, :b => 2, :c => 3})
  verify_that([:a, :b], [1, 2, 3]).returns({:a => 1, :b => 2})
  verify_that([:a, :b, :c], [1, 2]).returns({:a => 1, :b => 2})
  verify_that([], [1, 2, 3]).returns({})
  verify_that([], []).returns({})
  verify_that([:a, :b, :c], []).returns({})
  verify_that(nil, [1, 2, 3]).returns({})
  verify_that([:a, :b, :c], nil).returns({})
  verify_that(nil, nil).returns({})
  
  def test_convert_integers_to_active_records
    expected = flexmock("user") do |u|
      u.should_receive(:id).and_return(1)
      u.should_receive(:to_active_record).and_return(u)
    end
    flexmock(User, :find => expected, :to_active_record => expected)
    assert_equal(expected, expected.id.to_active_record(User))
    assert_equal(expected, expected.to_active_record(User))
  end
  
  def test_convert_active_records_to_id
    expected = flexmock("user", :id => 1, :to_active_record_id => 1)
    assert_equal(expected.id, expected.to_active_record_id)
    assert_equal(1, 1.to_active_record_id)
  end
  
  def test_convert_a_hash_to_a_query_string
    actual = {"a" => 1, "b" => 2}.to_query_string
    assert_equal("a=1&b=2", actual)
  end
  
  def test_convert_a_string_to_boolean
    assert "true".is_true?
    assert "1".is_true?
    assert "t".is_true?
    assert "T".is_true?
    assert !"false".is_true?
    assert !"".is_true?
    assert !({}[:a].is_true?)
    assert !(nil.is_true?)
  end
  
  def test_convert_a_string_to_a_hash
    actual = "a=1&b=2&c=fred".to_hash("&", "=")
    expected = {"a" => "1", "b" => "2", "c" => "fred"}
    assert_equal(expected, actual)
  end
  
  testbed "update hash keys" do |hash|
    hash.map_key {|key| key * 2}
  end
  verify_that({1 => :a, 2 => :b}).returns(2 => :a, 4 => :b)
  
  testbed "should return lowest missing number" do |list|
    list.lowest_missing_number
  end
  verify_that([1, 2, 3]).returns(4)
  verify_that([1, 2, 4]).returns(3)
  verify_that([]).returns(1)
  
  testbed "should create a hash" do |list|
    list.to_hash(&:size)
  end
  verify_that(["ab", "a"]).returns({2 => "ab", 1 => "a"})
  verify_that([]).returns({})
  
  testbed "convert date to week range" do |date|
    date.to_week_range.to_s(:db)
  end
  verify_that(Date.new(2008, 01, 02)).returns("BETWEEN '2007-12-30' AND '2008-01-06'")
  
  testbed "convert date to month range" do |date|
    date.to_month_range.to_s(:db)
  end
  verify_that(Date.new(2008, 01, 02)).returns("BETWEEN '2008-01-01' AND '2008-02-01'")
  verify_that(Date.new(2008, 02, 15)).returns("BETWEEN '2008-02-01' AND '2008-03-01'")
  
  testbed "smart string to integer" do |str|
    str.smart_to_i
  end
  verify_that("3").returns(3)
  verify_that("fred").returns("fred")
  verify_that("0").returns(0)
  verify_that(nil).returns(0)
  
  testbed "smart parse a date" do |str|
    new_date = Date.smart_parse(str, Date.new(2008, 1, 22))
    new_date.to_s(:db)
  end
  verify_that("February 5, 2008").returns("2008-02-05")
  verify_that(nil).returns("2008-01-22")
  verify_that("seven days from now").returns((Date.today + 7).to_s(:db))
  verify_that("February 30, 2008").returns("2008-03-01")
  verify_that("fred").returns("2008-01-22")
  
  def test_convert_smart_to_date
    assert_equal(Time.now.to_date, Time.now.smart_to_date)
    assert_equal(Date.today.to_date, Date.today.smart_to_date)
    assert_equal("2008-01-22", "2008-01-22".smart_to_date.to_s(:db))
  end
  
  def test_group_into_hash
    actual = %w{a b c}.group_into_hash {|e| e.to_sym}
    expected = {:a => ["a"], :b => ["b"], :c => ["c"]}
    assert_equal(expected, actual)
  end


  def test_yield_when_calling_if_nil_on_nil
    @block = Proc.new { true }
    assert nil.if_nil(&@block)
  end

  def test_not_yield_when_calling_if_not_nil_on_nil
    @block = Proc.new { true }
    assert_false nil.if_not_nil(&@block)
  end
    
  def test_yield_when_calling_if_nil_on_it
    @block = Proc.new { true }
    assert_false "".if_nil(&@block)
  end

  def test_not_yield_when_calling_if_not_nil_on_it
    @block = Proc.new { true }
    assert "".if_not_nil(&@block)
  end

  def test_pass_itself_to_if_not_nil
    obj = "abc"
    assert_same obj, obj.if_not_nil {|o| o}
  end
  
  def test_in
    assert "b".in?("a", "b", "c")
    assert "b".in?(["a", "b", "c"])
    assert_false "b".in?(1, 2, 3)
    assert_false nil.in?(1, 2, 3)
    assert_false "b".in?()
    assert_false "b".in?(nil)
  end
  
  def test_not_in
    assert "b".not_in?(1, 2, 3)
    assert nil.not_in?(1, 2, 3)
    assert "b".not_in?()
    assert "b".not_in?(nil)
    assert_false "b".not_in?("a", "b", "c")
    assert_false "b".not_in?(["a", "b", "c"])
  end


end