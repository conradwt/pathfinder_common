module JavascriptEffectsHelper
  
  def control_modal(div_id, options = {})
    to_open = if options.key?(:open) then options[:open] else true end
    options.delete(:open)
    option_strings = []
    options.each do |key, value|
      value = "'#{escape_javascript value}'" if value.is_a? String
      option_strings << "#{key}: #{value}" 
    end
    options_string = "{#{option_strings.join(', ')}}"
    result_string = "new Control.Modal('#{div_id}', #{options_string})";
    result_string = "m = #{result_string}; m.open();" if to_open
  end
  
  def close_control_modal()
    "Control.Modal.close();"
  end
  
  def crossfade(page, *dom_ids)
    dom_ids.each do |dom_id|
      page.visual_effect(:fade, dom_id, :duration => 0.5)
    end
    page.delay 0.5 do
      yield
      dom_ids.each do |dom_id|
        page.visual_effect(:appear, dom_id, :duration => 1.0)
      end
    end
  end
  
end