module PathfinderHelper
  
  def header_row(*captions)
    cells = captions.collect { |each| "<th>#{each}</th>"}
    "<tr>#{cells.join("")}</tr>"
  end
  
  def to_table_row(obj, *columns)
    Html.tr(:id => dom_id(obj, :row)) do |tr|
      columns.each do |col|
        content = if obj.respond_to?(col) then obj.send(col) else self.send(col, obj) end
        tr << Html.td(content, :id => dom_id(obj, "column_#{col}"))
      end
    end
  end
  
  def to_table_rows(objects, *columns)
    objects.map { |o| to_table_row(o, *columns) }.join("\n")
  end
  
  def smart_dom_id(object, prefix)
    if object.is_a? String 
      return "#{prefix.to_s.gsub(" ", "_")}_#{object.gsub(" ", "_")}"
    end
    dom_id(object, prefix)
  end
  
end

ActionView::Base.send(:include, PathfinderHelper)