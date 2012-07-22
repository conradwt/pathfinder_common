require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/helper_test_class' 

class TabularFormBuilderTest < HelperTestClass
  include ActionController::PolymorphicRoutes
  include TabularFormBuilderHelper
  set_controller_class MockController
  
  def setup
    super
    @object = flexmock()
    @object.should_receive(:company_name).and_return("Alpha Law")
    @object.should_receive(:status).and_return(1)
    @object.should_receive(:id).and_return(1)
    @builder = TabularFormBuilder.new(:account, @object, @template, {}, nil)
  end
  
  def make_response(text)
    @response.body = text 
  end
      
  def test_should_build_input_fields 
    make_response @builder.text_field(:company_name)
    assert_select "tr" do
      assert_select "td.tdheader"
      assert_select "label[for *= account_company_name]", "Company Name"
      assert_select "td" do 
        assert_select "input.text_field#account_company_name[name *= company_name][size = '30'][value = 'Alpha Law']"
      end
    end
  end
  
  def test_build_with_a_caption
    make_response @builder.text_field(:company_name, :caption => "Company",
        :caption_class => "caption_thing")
    assert_select "tr" do
      assert_select "td.caption_thing"
      assert_select "label[for *= account_company_name]", "Company"
      assert_select "td" do
        assert_select "input.text_field#account_company_name[name *= company_name][size = '30'][value = 'Alpha Law']"
      end
    end
  end
  
  def test_allow_caption_above_data_field
    make_response @builder.text_field(:company_name, 
        :data_caption_above => "Full name, please", :data_caption_below => "help me")
    assert_select "tr" do
      assert_select "label[for *= account_company_name]", "Company Name"
      assert_select "td" do
        assert_select "div.smallcaption", "Full name, please"
        assert_select "input.text_field#account_company_name[name *= company_name][size = '30'][value = 'Alpha Law']"
        assert_select "div.smallcaption", "help me"
      end
    end
  end
   
  def test_build_with_required_field
    make_response @builder.text_field(:company_name, :required => true)
    assert_select "tr" do
      assert_select "td.tdheader"
      assert_select "label[for *= account_company_name]", "Company Name"
      assert_select "span.required", "*"
      assert_select "td" do
        assert_select "input.text_field#account_company_name[name *= company_name][size = '30'][value = 'Alpha Law']"
      end
    end
  end
  
  def test_build_with_row_block
    make_response @builder.row { "howdy" }
    assert_select "tr" do
      assert_select "td[colspan = '2']", "howdy"
    end
  end
  
  
  def test_build_select
    make_response @builder.select(:status, [["Active", 1], ["Inactive", -1]])
    assert_select "tr" do
      assert_select "td.tdheader"
      assert_select "label[for *= status]", "Status"
      assert_select "td" do
        assert_select "select.select#account_status[name *= status]" do
          assert_select "option[value = 1]", "Active"
          assert_select "option[value = -1]", "Inactive"
        end
      end
    end
  end
  
  def test_build_a_select_with_prompt
    @object.should_receive(:fred).and_return(nil)
    make_response @builder.select(:fred, [["Active", 1], ["Inactive", -1]], 
        {:prompt => "Please Select"})
    assert_select "tr" do
      assert_select "td.tdheader"
      assert_select "label[for *= fred]", "Fred"
      assert_select "td" do
        assert_select "select.select#account_fred[name *= fred]" do
          assert_select "option", "Please Select"
          assert_select "option[value = 1]", "Active"
          assert_select "option[value = -1]", "Inactive"
        end
      end
    end
  end
  
  def test_build_a_select_with_include_blank
    make_response @builder.select(:status, [["Active", 1], ["Inactive", -1]], 
        :include_blank => "Please Select")
    assert_select "tr" do
      assert_select "td.tdheader"
      assert_select "label[for *= status]", "Status"
      assert_select "td" do
        assert_select "select.select#account_status[name *= status]" do
          assert_select "option", "Please Select"
          assert_select "option[value = 1]", "Active"
          assert_select "option[value = -1]", "Inactive"
        end
      end
    end
  end
  
  def test_build_a_country_select_with_prompt
    @object.should_receive(:country).and_return(nil)
    make_response @builder.country_select(:country, ['United States','Canada'], 
        {:prompt => 'Select Country'})
    assert_select "tr" do
      assert_select "td.tdheader"
      assert_select "label[for *= country]", "Country"
      assert_select "td" do
        assert_select "select.country_select#account_country[name *= country]" do
          assert_select "option", "Select Country"
          assert_select "option", "United States"
          assert_select "option", "Canada"
        end
      end
    end
  end
  
  
  def test_build_radio_buttons
    make_response @builder.radio_buttons(:status, %w{Active Inactive})
    assert_select "tr" do
      assert_select "td.tdheader"
      assert_select "label[for *= status]", "Status"
      assert_select "td" do
        assert_select "span.radio_caption", "Active"
        assert_select "input.radio_buttons#account_status_active[name *= status][value = 'Active'][type = 'radio']"
        assert_select "span.radio_caption", "Inactive"
        assert_select "input.radio_buttons#account_status_inactive[name *= status][value = 'Inactive'][type = 'radio']"
      end
    end
  end 
  
  def test_build_a_submit_button
    make_response @builder.submit("Go!")
    assert_select "tr" do
      assert_select "td" do
        assert_select "input[type = submit][value = Go!]"
      end
    end
  end
  
  def flex_mock_path(arg)
    "path"
  end
  
  def test_build_a_table  
    form = table_form_for @object do |f|
      _erbout << f.text_field(:company_name)
    end
    make_response(form.join("\n"))
    assert_select "table" do
      assert_select "form" do
        assert_select "tr" do
          assert_select "td.tdheader"
          assert_select "label[for *= flex_mock_company_name]", "Company Name"
          assert_select "td" do
            assert_select "input.text_field#flex_mock_company_name[name *= company_name][size = '30'][value = 'Alpha Law']"
          end
        end
      end
    end
  end
    
end
