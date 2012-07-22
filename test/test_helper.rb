parent_dir = "#{File.dirname(__FILE__)}/.."
plugin_dir = "#{File.dirname(__FILE__)}/../.."
Rails.root = "#{plugin_dir}/../../"
require "#{Rails.root}/vendor/rails/activesupport/lib/active_support"
require "#{Rails.root}/vendor/rails/actionpack/lib/action_pack"
require "#{Rails.root}/vendor/rails/actionpack/lib/action_controller"
require "#{Rails.root}/vendor/rails/actionpack/lib/action_controller/test_process"
require "#{Rails.root}/vendor/rails/actionpack/lib/action_view"
#require "#{Rails.root}/vendor/rails/railties/lib/initializer"
#Rails::Initializer.run(:set_load_path)
require "#{parent_dir}/lib/active_record_id_extensions"
require "#{parent_dir}/lib/date_extensions"
require "#{parent_dir}/lib/enumerable_extensions"
require "#{parent_dir}/lib/javascript_effects_helper"
require "#{parent_dir}/lib/hash_extensions"
require "#{parent_dir}/lib/object_extensions"
require "#{parent_dir}/lib/tabular_form_builder"
require "#{parent_dir}/lib/string_extensions"
require 'chronic'
require 'flexmock/test_unit'
require 'pp'

module Test
  module Unit
    class TestCase
      def assert_false(value)
        assert !value
      end
    end
  end
end