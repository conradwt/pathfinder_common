module TabularFormBuilderHelper
  
  def convert_args(builder_class, args)
    options = args.last.is_a?(Hash) ? args.pop : {} 
    options = options.merge(:builder => builder_class) 
    args = (args << options)
  end
  
  def table_form_for(name, *args, &proc)
    concat("<table>", proc.binding) 
    form_for(name, *convert_args(TabularFormBuilder, args), &proc) 
    concat("</table>", proc.binding) 
  end

  def remote_table_form_for(name, *args, &proc)
    remote_form_for(name, *convert_args(TabularFormBuilder, args), &proc) 
  end
end

class TabularFormBuilder < ActionView::Helpers::FormBuilder
  
  class << self 
    def build_tabular_field(method_name)
      define_method("#{method_name}_with_builder") do | attribute, *args |
        element_builder = TableFormElementBuilder.new(self, @template,
            method_name, attribute, args)
        element_builder.render_row(@template)
      end
      alias_method_chain method_name, :builder unless method_name == :radio_buttons
      alias_method :radio_buttons, :radio_buttons_with_builder if method_name == :radio_buttons
    end
  end
  
  row_helpers = field_helpers - %w(label hidden_field apply_form_for_options!)
  row_helpers.each do | method_name | 
    build_tabular_field(method_name)
  end 
  build_tabular_field(:select)
  build_tabular_field(:country_select)
  build_tabular_field(:date_select)
  build_tabular_field(:radio_buttons)
  
  def submit(caption, args={})
    row(super(caption, args))
  end
  
  def row(content = nil)
    @template.content_tag("tr") do
      @template.content_tag("td", :colspan => 2) do
        "#{content}" + 
        "#{yield if block_given?}"
      end 
    end
  end
  
  def header_row(content = nil)
    @template.content_tag("tr") do
      @template.content_tag("th", :colspan => 2) do
        "#{content}" + 
        "#{yield if block_given?}"
      end 
    end
  end
  
  def spacer
    "<tr><td colspan='2'>&nbsp;</td></tr>"
  end
  
end

class TableFormElementBuilder
  
  attr_accessor :data, :options, :caption, :caption_class, :template
  attr_accessor :builder, :required, :attribute, :method_name
  attr_accessor :data_caption_above, :data_caption_below, :helper_options
  
  def initialize(builder, template, method_name, attribute, args)
    @builder = builder
    @template = template
    @data = args[0]
    @attribute = attribute
    @method_name = method_name
    build_options(attribute, args)
  end
  
  def cell_text
    above_caption + element_text + after_caption
  end
  
  def above_caption
    data_caption data_caption_above
  end
  
  def after_caption
    data_caption data_caption_below
  end
  
  def data_caption(data)
    return "" unless data
    template.content_tag(:div, data, :class => "smallcaption")
  end
  
  def element_text
    if method_name == :radio_buttons
      data.collect do |value| 
        template.content_tag(:span, value, :class => "radio_caption") +
        builder.radio_button_without_builder(*arg_list(value)) 
      end.join(" ")
    else
      builder.send("#{method_name}_without_builder", *arg_list)
    end
  end
  
  def arg_list(value = nil)
    value ||= data
    if method_name == :select || method_name == :country_select then 
      return [attribute, value, helper_options, options]
    elsif method_name == :radio_buttons then
      return [attribute, value, options]
    end
    [attribute, options]
  end
  
  def build_helper_options
    keys = [:prompt, :include_blank]
    @helper_options = @options.slice(*keys)
    @options = @options.except(*keys)
  end
  
  def build_options(attribute, args)
    @options = if args[-1].is_a?(Hash) then args[-1] else {} end
    build_helper_options
    @caption = options.delete(:caption) || attribute.to_s.humanize.titlecase
    @caption_class = options.delete(:caption_class) || "tdheader"
    @required = options.delete(:required) || false
    @data_caption_above = options.delete(:data_caption_above) || nil
    @data_caption_below = options.delete(:data_caption_below) || nil
    @options[:class] ||= @method_name
  end
  
  def render_row(template)
    template.content_tag("tr") do        
      caption_content(template) + cell_content(template, cell_text)
    end
  end
  
  def caption_content(template)
    content = builder.label(attribute, caption)
    content += required_span(template) if required
    template.content_tag("td", content, :class => caption_class) 
  end

  def required_span(template)
    template.content_tag(:span, "*", :class => "required")
  end

  def cell_content(template, text)
    template.content_tag("td", text)
  end
  
end
