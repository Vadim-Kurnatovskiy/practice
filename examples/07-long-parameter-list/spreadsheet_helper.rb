module SpreadsheetHelper
  def push_table(sheet, headers, items, widths, current_row)
    default_format = Spreadsheet::Format.new :size => 10
    header_format = Spreadsheet::Format.new({
      :size => 10,
      :weight => :bold,
      :text_wrap => true,
      :border => :thin,
      :horizontal_align => :center,
      :vertical_align => :center
    })
    table_format = Spreadsheet::Format.new({
      :size => 10,
      :text_wrap => true,
      :border => :thin,
      :vertical_align => :top
    })
    table_format_gray = Spreadsheet::Format.new({
      :size => 10,
      :text_wrap => true,
      :border => :thin,
      :vertical_align => :top,
      :pattern_bg_color => :silver, :pattern_fg_color => :silver, :pattern => 1
    })
    table_formats = [table_format, table_format_gray]

    widths.each_with_index do |width, index|
      sheet.format_column(index, default_format, {:width => width/5.55})
    end


    headers.each_with_index do |header, index|
      sheet.row(current_row).push header
      sheet.row(current_row).set_format(index, header_format)
    end
    current_row += 1
    items.each do |values|
      values.each_with_index do |value, index|
        sheet.row(current_row).push value.to_s.gsub("\r\n", "\n")
        sheet.row(current_row).set_format(index, table_formats[(current_row + 1).divmod(2)[1]])
      end
      current_row += 1
    end
    current_row
  end

end
