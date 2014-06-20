
module Collimator

  module Table

    @horiz   = '-'
    @border  = '|'
    @corner  = '+'
    @columns = []
    @rows    = []
    @headers = []
    @footers = []
    @column_names = []
    @use_column_headings = false
    @auto_clear = true
    @separators = []
    @live_update = false
    @table_string = []
    @use_capture_string = false
    @use_capture_html = false
    @last_header_color = '#EEEEEE'

    def self.live_update=(live_upate)
      @live_update = live_upate
    end

    def self.live_update
      @live_update
    end

    def self.set_auto_clear(auto_clear = true)
      @auto_clear = auto_clear
    end

    def self.set_corner(corner_character)
      @corner = corner_character
    end

    def self.set_border(border_character)
      @border = border_character
    end

    def self.set_horizontal(horizontal_character)
      @horiz = horizontal_character
    end

    def self.header(text, opts = {})
      width, padding, justification, color = parse_options(opts)

      @headers << { :text => text, :padding => padding, :justification => justification , :color => color}
    end

    def self.footer(text, opts)
      width, padding, justification = parse_options(opts)

      @footers << { :text => text, :padding => padding, :justification => justification }
    end

    def self.column(heading, opts = {})
      width, padding, justification, color = parse_options(opts)

      @columns << { :width => width, :padding => padding, :justification => justification, :color => color }
      @use_column_headings = true if heading.length > 0
      @column_names << heading
    end

    def self.row(row)
      colored_data_array = []
      if row.class.to_s == "Hash"
        colored_data_array = row[:data].map { |v| {:data => v, :color => row[:color] } }
      else
        colored_data_array = row.clone
      end
      if @live_update
        put_line_of_data(colored_data_array)
      else
        @rows << colored_data_array
      end
    end

    def self.separator
      if @live_update
        put_horizontal_line_with_dividers
      else
        @separators << @rows.length
      end
    end

    def self.tabulate
      put_header
      put_column_heading_text
      prep_data
      put_table
      put_horizontal_line
      put_footer

      clear_all if @auto_clear
    end

    def self.tabulate_to_string
      @use_capture_html = false
      @use_capture_string = true
      @auto_clear = false
      tabulate
      @table_string.join("\n")
    end

    def self.tabulate_to_html
      @use_capture_string = false
      @use_capture_html = true
      @auto_clear = false

      prep_html_table
      tabulate
      complete_html_table

      @table_string.join("\n")
    end

    def self.prep_html_table
      @table_string = []
      @table_string << "<table STYLE=\"font-family: helvetica, verdana, tahoma; border-collapse: collapse;\">"
    end

    def self.complete_html_table
      @table_string << "</table>"
    end

    def self.start_live_update
      put_header
      put_column_heading_text
    end

    def self.complete_live_update
      put_horizontal_line
      put_footer

      clear_all if @auto_clear
    end

    def self.csv
      lines = []

      lines.concat(@headers.map { |h| h[:text] }) if @headers.count > 0
      lines << @column_names.join(',') if @use_column_headings
      @rows.each { |row| lines << row.join(',') }
      lines.concat(@footers.map { |h| h[:text] }) if @headers.count > 0

      out = lines.join("\n")

      clear_all if @auto_clear

      out
    end

    def self.clear_all
      @columns = []
      @rows    = []
      @headers = []
      @footers = []
      @column_names = []
      @use_column_headings = false
      @horiz   = '-'
      @border  = '|'
      @corner  = '+'
      @auto_clear = true
      @separators = []
      @live_update = false
      @table_string = []
      @use_capture_string = false
      @use_capture_html   = false
    end

    def self.clear_data
      @rows       = []
      @separators = []
    end

    private

    def self.send_line(line)
      if @use_capture_string || @use_capture_html
        @table_string << line
      else
        puts line
      end
    end

    def self.parse_options(opts)
      width         = opts.has_key?(:width) ? opts[:width] : 10
      padding       = opts.has_key?(:padding) ? opts[:padding] : 0
      justification = opts.has_key?(:justification) ? opts[:justification] : :center
      col_color     = opts.has_key?(:color) ? opts[:color] : nil

      padding = 0 if justification == :decimal

      [width, padding, justification, col_color]
    end

    def self.put_table
      put_horizontal_line if @headers.length == 0 and !@use_column_headings
      row_number = 0
      @table_string << "<tbody>" if @use_capture_html
      @rows.each do |row|
        put_horizontal_line_with_dividers if @separators.include?(row_number)
        put_line_of_data(row)
        row_number += 1
      end
      @table_string << "</tbody>" if @use_capture_html
    end

    def self.prep_data
      column = 0
      @columns.each do  |c|
        if c[:justification] == :decimal
          column_width  = c[:width]
          column_center = column_width / 2
          values = []
          @rows.each do |r|
            value = r[column].class.to_s == "Hash" ? r[column][:data]  : r[column].to_s
            color = r[column].class.to_s == "Hash" ? r[column][:color] : nil

            v2 = value
            decimal_place = v2.index('.') ? v2.index('.') : v2.length
            v2 = ' '*(column_center -decimal_place) + v2
            v2 = v2.ljust(column_width)

            v2 = {:data => v2, :color => color} if color
            values << v2
          end

          row = 0
          @rows.each do |r|
            r[column] = values[row]
            row += 1
          end
        end

        if c[:color]
          @rows.each do |r|
            value = ''
            color = nil
            if r[column].class.to_s == "Hash"   # don't change the data point color if already set. single data point color overrides column color.
              color = r[column][:color]
              value = r[column][:data]
            else
              color = c[:color]
              value = r[column]
            end
            r[column] = {:data => value, :color => color}
          end
        end
        column += 1
      end
    end

    def self.prep_data_orig
      column = 0
      @columns.each do  |c|
        if c[:justification] == :decimal
          column_width  = c[:width]
          column_center = column_width / 2
          values = []
          length = 0
          decimal_place = 0
          @rows.each do |r|
            value = r[column].class.to_s == "Hash" ? r[column][:data] : r[column].to_s
            values << value
            length = value.length if value.length > length
          end
          values = values.map { |v| v.ljust(length) }
          values.each do |value|
            decimal_place = value.index('.') if (value.index('.') and (value.index('.') > decimal_place))
          end
          values = values.map do |v|
            place = v.index('.') ? v.index('.') : v.length
            ' '*(decimal_place - place) + v
          end

          row = 0
          @rows.each do |r|
            r[column] = values[row]
            row += 1
          end
        end

        if c[:color]
          @rows.each do |r|
            value = ''
            color = nil
            if r[column].class.to_s == "Hash"   # don't change the data point color if already set. single data point color overrides column color.
              color = r[column][:color]
              value = r[column][:data]
            else
              color = c[:color]
              value = r[column]
            end
            r[column] = {:data => value, :color => color}
          end
        end
        column += 1
      end
    end

    def self.put_column_heading_text
      @use_capture_html ? put_column_heading_text_html : put_column_heading_text_string if @use_column_headings
    end

    def self.put_column_heading_text_string
      put_line_of_data(@column_names)
      put_horizontal_line_with_dividers
    end

    def self.style_color(rgb)
      luminance = get_luminance(rgb)
      color = luminance < 50 ? '#EEEEEE' : '#222222'
      color_style = "color: #{color};"
    end

    def self.style_header_border(rgb)
      luminance = get_luminance(rgb)
      color = luminance < 50 ? '#EEEEEE' : '#222222'
      color_style = "border-bottom: 1px solid #{color};"
    end

    def self.get_luminance(rgb)
      rgb_temp = rgb.gsub("#", '')
      luminance = 0
      if rgb_temp.length == 6
        r = rgb_temp[0..1].hex
        g = rgb_temp[2..3].hex
        b = rgb_temp[4..5].hex
        luminance = (0.299*r + 0.587*g + 0.114*b)
      end
      luminance
    end

    def self.put_column_heading_text_html
      c = @last_header_color
      text_color = style_color(c)
      border_color = style_header_border(c)
      out = "<tr STYLE=\"background-color: #{@last_header_color}; #{text_color} #{border_color}\">\n"
      column = 0
      @column_names.each do |cname|
        padding_style = @columns[column][:padding] ? "STYLE=\"padding-left: #{@columns[column][:padding]}em; padding-right: #{@columns[column][:padding]}em;\"" : ""
        out += "<th #{padding_style}>#{cname}</th>\n"
        column += 1
      end

      out += "</tr>\n"
      out += "</thead>"

      send_line out
    end

    def self.put_header_or_footer(header_or_footer = :header)
      data = header_or_footer == :footer ? @footers.clone : @headers.clone

      unless @use_capture_html
        if header_or_footer == :header and data.length > 0
          put_horizontal_line
        end
      end

      return if data.length == 0

      @table_string << "<thead>" if @use_capture_html if header_or_footer == :header

      data.each do | header |
        send_line make_header_line(header)
      end

      put_horizontal_line
    end

    def self.make_header_line(data)
      out = @use_capture_html ? make_header_line_html(data) : make_header_line_string(data)
      out
    end

    def self.make_header_line_string(header)
      header_width = line_width
      header_line =  @border
      header_line += ' '*header[:padding] if header[:justification] == :left
      header_line += header[:text].center(header_width - 2) if header[:justification] == :center
      header_line += header[:text].ljust(header_width - header[:padding] - 2) if header[:justification] == :left
      header_line += header[:text].rjust(header_width - header[:padding] - 2) if header[:justification] == :right
      header_line += ' '*header[:padding] if header[:justification] == :right

      header_line += @border
    end

    def self.make_header_line_html(data)
      @last_header_color = data[:color] || @last_header_color

      text_color = style_color(@last_header_color)
      header_line =  "<tr>"
      header_line += "<th STYLE=\"background-color: #{@last_header_color}; #{text_color}\" colspan='#{@column_names.count + 1}'>#{data[:text]}</th>"
      header_line += "</tr>"
      header_line
    end

    def self.put_footer
      put_header_or_footer(:footer) unless @use_capture_html
    end

    def self.put_header
      put_header_or_footer(:header)
    end

    def self.line_width
      @columns.length + 1 + @columns.inject(0) { |sum, c| sum + c[:width] + c[:padding] }
    end

    def self.format_data(value, width, padding, justification)
      data_value = value.class.to_s == "Hash" ? value[:data] : value

      s = ''
      s = data_value.to_s
      s = ' '*padding + s.ljust(width) if justification == :left
      s = s.rjust(width) + ' '*padding if justification == :right
      s = s.center(width) if justification == :center || justification == :decimal
      #s = s.send(value[:color].to_s) if value.class.to_s == "Hash"
      s = s.gsub(data_value.to_s, data_value.to_s.send(value[:color])) if value.class.to_s == "Hash"
      s
    end

    def self.put_row_of_html_data(row_data)
      column = 0
      row_string = "<tr>\n"

      row_data.each do | val |
        style_info = @columns[column][:padding] ? " STYLE=\"padding-left: #{@columns[column][:padding]}em; padding-right: #{@columns[column][:padding]}em;\"" : ''
        row_string += "<td#{style_info}>#{val}</td>\n"
        column += 1
      end

      row_string += "</tr>"

      send_line row_string
    end

    def self.put_row_of_string_data(row_data)
      column = 0
      row_string = @border

      row_data.each do | val |
        s = format_data(val, @columns[column][:width], @columns[column][:padding], @columns[column][:justification])
        row_string = row_string + s + @border
        column += 1
      end

      send_line row_string
    end

    def self.put_line_of_data(row_data)
      raise TooManyDataPoints if row_data.count > @columns.length

      row_data << '' while row_data.length < @columns.length

      if @use_capture_html
        put_row_of_html_data row_data
      else
        put_row_of_string_data row_data
      end
    end

    def self.put_horizontal_line
      unless @use_capture_html
        width = line_width
        send_line @corner + @horiz * (width - 2) + @corner
      end
    end

    def self.put_horizontal_line_with_dividers
      unless @use_capture_html
        a = []
        @columns.each { | c | a << @horiz*(c[:width] + c[:padding]) }
        s = @border + a.join(@corner) + @border
        send_line s
      end
    end
  end
end