require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/helper_test_class' 

class JavascriptEffectsHelperTest < HelperTestClass
  include JavascriptEffectsHelper
  set_controller_class MockController
  
  def test_control_modal
    actual = control_modal("a_div", :content => "content")
    assert_equal("m = new Control.Modal('a_div', {content: 'content'}); m.open();", actual)
  end
  
  def test_control_model_with_numeric_argument
    actual = control_modal("a_div", :content => "content", :offsetTop => 20)
    assert_match(/offsetTop: 20/, actual)
  end
  
  def test_control_model_with_boolean_argument
    actual = control_modal("a_div", :content => "content", :fade => true)
    assert_match(/fade: true/, actual)
  end
  
  def test_close_control_modal
    assert_equal("Control.Modal.close();", close_control_modal)
  end
  
  def test_crossfade
    page = flexmock("page")
    page.should_receive(:visual_effect).with(:fade, "dom_1", :duration => 0.5).once.ordered(:first)
    page.should_receive(:visual_effect).with(:fade, "dom_2", :duration => 0.5).once.ordered(:first)
    page.should_receive(:delay).and_yield.once.ordered
    page.should_receive(:replace_html).once.ordered
    page.should_receive(:visual_effect).with(:appear, "dom_1", :duration => 0.5).once.ordered(:last)
    page.should_receive(:visual_effect).with(:appear, "dom_2", :duration => 0.5).once.ordered(:last)
    crossfade(page, "dom_1", "dom_2") do
      page.replace_html()
    end
  end
  
end