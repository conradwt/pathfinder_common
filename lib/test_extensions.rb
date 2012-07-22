class Test::Unit::TestCase
  def assert_false(value, extra_message = nil)
    assert !value, extra_message
  end
  
  def assert_equal_methods(expected, actual, *methods)
    methods.each do |method|
      assert_equal(expected.send(method), actual.send(method),
          "For method #{method} expected <#{expected.send(method)}>, got <#{actual.send(method)}>")
    end
  end
  
  def assert_methods(actual, methods = {})
    methods.each do |method, value|
      assert_equal(value, actual.send(method),
          "For method #{method} expected <#{value}>, got <#{actual.send(method)}>")
    end
  end
  
  def assert_response_form(methods, id, *selectors)
    methods.each do |method|
      get method, :id => id
      assert_response :success
      assert_form(*selectors)
    end
  end
  
  def assert_form(*selectors)
    assert_select "form" do
      selectors.each do |sel|
        if sel[0] == "select"
          assert_select "#{sel[0]}[name *= ?]", sel[1] do
            sel[2..-1].each do |text|
              assert_select "option", text 
            end
          end
        else
          assert_select "#{sel[0]}[name *= ?]", sel[1]
        end
      end
    end
  end
  
  def assert_select_tag(name, *options)
    assert_select "select[name = ?]", name do
      assert_select 'option', :count => options.size
      options.each do |option|
        assert_select "option", option
      end
    end
  end
  
end