require 'test/unit'
require 'tabula'
require 'date'
require 'stringio'
require 'test_helper'

class TestTable < Test::Unit::TestCase
  include Tabula

  def setup
    Table.clear_all
  end

  def teardown
    $stdout = STDOUT
  end

  def test_just_table

    header_text = ['head A', 'head B', 'head C']
    header_width = [12, 10, 14]
    col_just = [:left, :right, :left]
    table_header = 'a table of stuff'

    Table.header(table_header, :padding => 4, :justification => :left)
    Table.header('second', :padding => 1, :justification => :right)

    (0..header_text.length - 1).each do |i|
      Table.column(header_text[i], :width => header_width[i], :padding => 2, :justification => col_just[i])
    end

    (1..5).each do |i|
      data = [i, (i+32).chr.to_s, i*i]
      Table.row(data)
    end

    Table.footer("this data is for practice", :padding => 1, :justification => :center)

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")
    assert_equal 14, table_lines.length

    assert_equal '+--------------------------------------------+', table_lines[0]
    assert_equal '|    a table of stuff                        |', table_lines[1]
    assert_equal '|                                     second |', table_lines[2]
    assert_equal '+--------------------------------------------+', table_lines[3]
    assert_equal '|  head A      |    head B  |  head C        |', table_lines[4]
    assert_equal '|--------------+------------+----------------|', table_lines[5]
    assert_equal '|  1           |         !  |  1             |', table_lines[6]
    assert_equal '|  2           |         "  |  4             |', table_lines[7]
    assert_equal '|  3           |         #  |  9             |', table_lines[8]
    assert_equal '|  4           |         $  |  16            |', table_lines[9]
    assert_equal '|  5           |         %  |  25            |', table_lines[10]
    assert_equal '+--------------------------------------------+', table_lines[11]
    assert_equal '|         this data is for practice          |', table_lines[12]
    assert_equal '+--------------------------------------------+', table_lines[13]

  end

  def test_just_table__empty_data_locations
    header_text = ['head A', 'head B', 'head C']
    header_width = [12, 10, 14]
    col_just = [:left, :right, :left]
    table_header = 'a table of stuff'

    Table.header(table_header, :padding => 4, :justification => :left)
    Table.header('second', :padding => 1, :justification => :right)

    (0..header_text.length - 1).each do |i|
      Table.column(header_text[i], :width => header_width[i], :padding => 2, :justification => col_just[i])
    end

    (1..5).each do |i|
      data = [i, (i+32).chr.to_s, i*i]

      if i == 1
        data = [i]
      end
      if i == 3
        data = [i, (i+32).chr.to_s]
      end
      if i == 4
        data = []
      end
      Table.row(data)
    end

    Table.footer("this data is for practice", :padding => 1, :justification => :center)

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")

    assert_equal 14, table_lines.length

    assert_equal '+--------------------------------------------+', table_lines[0]
    assert_equal '|    a table of stuff                        |', table_lines[1]
    assert_equal '|                                     second |', table_lines[2]
    assert_equal '+--------------------------------------------+', table_lines[3]
    assert_equal '|  head A      |    head B  |  head C        |', table_lines[4]
    assert_equal '|--------------+------------+----------------|', table_lines[5]
    assert_equal '|  1           |            |                |', table_lines[6]
    assert_equal '|  2           |         "  |  4             |', table_lines[7]
    assert_equal '|  3           |         #  |                |', table_lines[8]
    assert_equal '|              |            |                |', table_lines[9]
    assert_equal '|  5           |         %  |  25            |', table_lines[10]
    assert_equal '+--------------------------------------------+', table_lines[11]
    assert_equal '|         this data is for practice          |', table_lines[12]
    assert_equal '+--------------------------------------------+', table_lines[13]

  end

  def test_just_table__with_separator
    header_text = ['head A', 'head B', 'head C']
    header_width = [12, 10, 14]
    col_just = [:left, :right, :left]
    table_header = 'a table of stuff'

    Table.header(table_header, :padding => 4, :justification => :left)
    Table.header('second', :padding => 1, :justification => :right)

    (0..header_text.length - 1).each do |i|
      Table.column(header_text[i], :width => header_width[i], :padding => 2, :justification => col_just[i])
    end

    (1..5).each do |i|
      data = [i, (i+32).chr.to_s, i*i]
      if i == 3
        Table.separator
      end
      Table.row(data)
    end

    Table.footer("this data is for practice", :padding => 1, :justification => :center)

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")

    assert_equal 15, table_lines.length

    assert_equal '+--------------------------------------------+', table_lines[0]
    assert_equal '|    a table of stuff                        |', table_lines[1]
    assert_equal '|                                     second |', table_lines[2]
    assert_equal '+--------------------------------------------+', table_lines[3]
    assert_equal '|  head A      |    head B  |  head C        |', table_lines[4]
    assert_equal '|--------------+------------+----------------|', table_lines[5]
    assert_equal '|  1           |         !  |  1             |', table_lines[6]
    assert_equal '|  2           |         "  |  4             |', table_lines[7]
    assert_equal '|--------------+------------+----------------|', table_lines[8]
    assert_equal '|  3           |         #  |  9             |', table_lines[9]
    assert_equal '|  4           |         $  |  16            |', table_lines[10]
    assert_equal '|  5           |         %  |  25            |', table_lines[11]
    assert_equal '+--------------------------------------------+', table_lines[12]
    assert_equal '|         this data is for practice          |', table_lines[13]
    assert_equal '+--------------------------------------------+', table_lines[14]

  end

  def test_change_border_horizontal_and_corner_characters

    header_text = ['head A', 'head B', 'head C']
    header_width = [12, 10, 14]
    col_just = [:left, :right, :left]
    table_header = 'a table of stuff'

    Table.set_border '.'
    Table.set_horizontal '='
    Table.set_corner '0'

    Table.header(table_header, :padding => 4, :justification => :left)
    Table.header('second', :padding => 1, :justification => :right)

    (0..header_text.length - 1).each do |i|
      Table.column(header_text[i], :width => header_width[i], :padding => 2, :justification => col_just[i])
    end

    (1..5).each do |i|
      data = [i, (i+32).chr.to_s, i*i]
      Table.row(data)
    end

    Table.footer("this data is for practice", :padding => 1, :justification => :center)

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")
    assert_equal 14, table_lines.length

    assert_equal '0============================================0', table_lines[0]
    assert_equal '.    a table of stuff                        .', table_lines[1]
    assert_equal '.                                     second .', table_lines[2]
    assert_equal '0============================================0', table_lines[3]
    assert_equal '.  head A      .    head B  .  head C        .', table_lines[4]
    assert_equal '.==============0============0================.', table_lines[5]
    assert_equal '.  1           .         !  .  1             .', table_lines[6]
    assert_equal '.  2           .         "  .  4             .', table_lines[7]
    assert_equal '.  3           .         #  .  9             .', table_lines[8]
    assert_equal '.  4           .         $  .  16            .', table_lines[9]
    assert_equal '.  5           .         %  .  25            .', table_lines[10]
    assert_equal '0============================================0', table_lines[11]
    assert_equal '.         this data is for practice          .', table_lines[12]
    assert_equal '0============================================0', table_lines[13]

  end

  def test_center_table

    header_text = ['head A', 'head B', 'head C']
    header_width = [12, 10, 14]
    col_just = [:center, :center, :center]
    table_header = 'a table of stuff'

    Table.header(table_header, :padding => 4, :justification => :left)
    Table.header('second', :padding => 1, :justification => :right)

    (0..header_text.length - 1).each do |i|
      Table.column(header_text[i], :width => header_width[i], :padding => 0, :justification => col_just[i])
    end

    (1..5).each do |i|
      data = [i, (i+32).chr.to_s, i*i]
      Table.row(data)
    end

    Table.footer("this data is for practice", :padding => 1, :justification => :center)

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")
    assert_equal 14, table_lines.length

    assert_equal '+--------------------------------------+', table_lines[0]
    assert_equal '|    a table of stuff                  |', table_lines[1]
    assert_equal '|                               second |', table_lines[2]
    assert_equal '+--------------------------------------+', table_lines[3]
    assert_equal '|   head A   |  head B  |    head C    |', table_lines[4]
    assert_equal '|------------+----------+--------------|', table_lines[5]
    assert_equal '|     1      |    !     |      1       |', table_lines[6]
    assert_equal '|     2      |    "     |      4       |', table_lines[7]
    assert_equal '|     3      |    #     |      9       |', table_lines[8]
    assert_equal '|     4      |    $     |      16      |', table_lines[9]
    assert_equal '|     5      |    %     |      25      |', table_lines[10]
    assert_equal '+--------------------------------------+', table_lines[11]
    assert_equal '|      this data is for practice       |', table_lines[12]
    assert_equal '+--------------------------------------+', table_lines[13]

  end

  def test_decimal_table

    header_text = ['name', 'decimal 1', 'decimal two']
    header_width = [12, 14, 20]
    col_just = [:right, :decimal, :decimal]
    table_header = 'a table of decimal stuff'

    Table.header(table_header, :padding => 4, :justification => :left)

    (0..header_text.length - 1).each do |i|
      Table.column(header_text[i], :width => header_width[i], :padding => (col_just == :decimal ? 0 : 2), :justification => col_just[i])
    end

    Table.row(['jim',    12.12, 0.004])
    Table.row(['george', 1.212, 0.04])
    Table.row(['bob',    121.2, 0.0004])
    Table.row(['joe',    121.2, 0])
    Table.row(['bill',    21.20, 10.1])

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")

    assert_equal '+--------------------------------------------------+', table_lines[0]
    assert_equal '|    a table of decimal stuff                      |', table_lines[1]
    assert_equal '+--------------------------------------------------+', table_lines[2]
    assert_equal '|        name  |  decimal 1   |    decimal two     |', table_lines[3]
    assert_equal '|--------------+--------------+--------------------|', table_lines[4]
    assert_equal '|         jim  |     12.12    |         0.004      |', table_lines[5]
    assert_equal '|      george  |      1.212   |         0.04       |', table_lines[6]
    assert_equal '|         bob  |    121.2     |         0.0004     |', table_lines[7]
    assert_equal '|         joe  |    121.2     |         0          |', table_lines[8]
    assert_equal '|        bill  |     21.2     |        10.1        |', table_lines[9]
    assert_equal '+--------------------------------------------------+', table_lines[10]
  end

  def test_table_just_data

    header_width = [12, 10, 14]
    col_just = [:right, :decimal, :decimal]

    (0..col_just.length - 1).each do |i|
      Table.column('', :width => header_width[i], :padding => (col_just == :decimal ? 0 : 2), :justification => col_just[i])
    end

    Table.row(['jim',    12.12, 0.004])
    Table.row(['george', 1.212, 0.04])
    Table.row(['bob',    121.2, 0.0004])

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")

    assert_equal '+----------------------------------------+', table_lines[0]
    assert_equal '|         jim  |   12.12  |      0.004   |', table_lines[1]
    assert_equal '|      george  |    1.212 |      0.04    |', table_lines[2]
    assert_equal '|         bob  |  121.2   |      0.0004  |', table_lines[3]
    assert_equal '+----------------------------------------+', table_lines[4]
  end

  def test_table_no_column_headings

    Table.header("Current User Credentials")
    Table.column('', :width => 16, :padding => 2, :justification => :right)
    Table.column('', :width => 24, :padding => 2, :justification => :left)

    Table.row ['display', 'geordie']
    Table.row ['password', 'dkdkdkdflsjlj']
    Table.row ['user', 'gspeake']

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")

    assert_equal '+---------------------------------------------+', table_lines[0]
    assert_equal '|          Current User Credentials           |', table_lines[1]
    assert_equal '+---------------------------------------------+', table_lines[2]
    assert_equal '|         display  |  geordie                 |', table_lines[3]
    assert_equal '|        password  |  dkdkdkdflsjlj           |', table_lines[4]
    assert_equal '|            user  |  gspeake                 |', table_lines[5]
    assert_equal '+---------------------------------------------+', table_lines[6]

  end
  
  def test_table__csv_output
    
    header_text  = ['head A', 'head B', 'head C']
    header_width = [12, 10, 14]
    col_just     = [:left, :right, :left]
    table_header = 'a table of stuff'

    Table.header(table_header, :padding => 4, :justification => :left)
    Table.header('second', :padding => 1, :justification => :right)

    (0..header_text.length - 1).each do |i|
      Table.column(header_text[i], :width => header_width[i], :padding => 2, :justification => col_just[i])
    end

    (1..5).each do |i|
      data = [i, (i+32).chr.to_s, i*i]
      Table.row(data)
    end

    Table.footer("this data is for practice", :padding => 1, :justification => :center)

    csv_output = Table.csv

    lines = csv_output.split("\n")
    assert_equal 9, lines.count
        
    assert_equal table_header, lines[0]
    assert_equal 'second', lines[1]
    assert_equal header_text.join(','), lines[2]
    
    assert_equal '1,!,1', lines[3]
    assert_equal '2,",4', lines[4]
    assert_equal '3,#,9', lines[5]
    assert_equal '4,$,16', lines[6]
    assert_equal '5,%,25', lines[7]
    assert_equal 'this data is for practice', lines[8]
  end

  def test_table__live_update_data
    header_text = ['head A', 'head B', 'head C']
    header_width = [12, 10, 14]
    col_just = [:left, :right, :left]
    table_header = 'a table of stuff'

    Table.clear_all
    Table.live_update = true

    Table.header(table_header, :padding => 4, :justification => :left)
    Table.header('second', :padding => 1, :justification => :right)

    (0..header_text.length - 1).each do |i|
      Table.column(header_text[i], :width => header_width[i], :padding => 2, :justification => col_just[i])
    end

    out = capture_output do
      Table.start_live_update
    end
    header_text = out.string
    header_lines = header_text.split("\n")
    assert_equal 6, header_lines.length

    assert_equal '+--------------------------------------------+', header_lines[0]
    assert_equal '|    a table of stuff                        |', header_lines[1]
    assert_equal '|                                     second |', header_lines[2]
    assert_equal '+--------------------------------------------+', header_lines[3]
    assert_equal '|  head A      |    head B  |  head C        |', header_lines[4]
    assert_equal '|--------------+------------+----------------|', header_lines[5]

    expected_lines = ['']
    expected_lines << '|  1           |         !  |  1             |'
    expected_lines << '|  2           |         "  |  4             |'
    expected_lines << '|  3           |         #  |  9             |'
    expected_lines << '|  4           |         $  |  16            |'
    expected_lines << '|  5           |         %  |                |'

    (1..5).each do |i|
      data = [i, (i+32).chr.to_s, i*i]
      data.pop if i == 5
      out = capture_output do
        Table.row(data)
        Table.separator if i == 3
      end
      
      line_text = out.string.chomp
      assert_equal expected_lines[i], line_text.split("\n")[0]
      assert_equal '|--------------+------------+----------------|', line_text.split("\n")[1] if i == 3
      
    end

    Table.footer("this data is for practice", :padding => 1, :justification => :center)

    out = capture_output do
      Table.complete_live_update
    end

    footer_text = out.string
    footer_lines = footer_text.split("\n")
    assert_equal 3, footer_lines.length
    
    assert_equal '+--------------------------------------------+', footer_lines[0]
    assert_equal '|         this data is for practice          |', footer_lines[1]
    assert_equal '+--------------------------------------------+', footer_lines[2]
  end

  def test_set_too_much_data
    Table.clear_all

    Table.header("test header", :padding => 4, :justification => :left)
    Table.column('column 1', :width => 10, :padding => 2, :justification => :left)
    Table.column('column 2', :width => 10, :padding => 2, :justification => :left)

    Table.row(["r1c1", "r1c2"])
    Table.row(["r2c1", "r2c2"])
    Table.row(["r3c1", "r3c2", "r3c3"])

    assert_raises TooManyDataPoints do
      out = capture_output do
        Table.tabulate
      end
    end
  end

  def test_color__single_cell
    Table.clear_all

    Table.header("test header", :padding => 4, :justification => :left)
    Table.column('column 1', :width => 10, :padding => 2, :justification => :left)
    Table.column('column 2', :width => 10, :padding => 2, :justification => :left)

    Table.row([{:data => "r1c1", :color => :red}, "r1c2"])
    Table.row(["r2c1", {:data => "r2c1", :color => :yellow}])
    Table.row(["r3c1", {:data => "r3c2", :color => :blue_on_white}])

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")

    assert_equal "+-------------------------+",                    table_lines[0]
    assert_equal "|    test header          |",                    table_lines[1]
    assert_equal "+-------------------------+",                    table_lines[2]
    assert_equal "|  column 1  |  column 2  |",                    table_lines[3]
    assert_equal "|------------+------------|",                    table_lines[4]
    assert_equal "|  #{"r1c1".red}      |  r1c2      |",           table_lines[5]
    assert_equal "|  r2c1      |  #{"r2c1".yellow}      |",        table_lines[6]
    assert_equal "|  r3c1      |  #{"r3c2".blue_on_white}      |", table_lines[7]
    assert_equal "+-------------------------+",                    table_lines[8]

  end

  def test_color__whole_row
    Table.clear_all

    Table.header("test header", :padding => 4, :justification => :left)
    Table.column('column 1', :width => 10, :padding => 2, :justification => :left)
    Table.column('column 2', :width => 10, :padding => 2, :justification => :left)

    Table.row(["r1c1", "r1c2"])
    Table.row({:data => ["r2c1", "r2c1"], :color => :yellow})
    Table.row(["r3c1", "r3c2"])

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")

    assert_equal "+-------------------------+",                         table_lines[0]
    assert_equal "|    test header          |",                         table_lines[1]
    assert_equal "+-------------------------+",                         table_lines[2]
    assert_equal "|  column 1  |  column 2  |",                         table_lines[3]
    assert_equal "|------------+------------|",                         table_lines[4]
    assert_equal "|  r1c1      |  r1c2      |",                         table_lines[5]
    assert_equal "|  #{"r2c1".yellow}      |  #{"r2c1".yellow}      |", table_lines[6]
    assert_equal "|  r3c1      |  r3c2      |",                         table_lines[7]
    assert_equal "+-------------------------+",                         table_lines[8]

  end

  def test_color__whole_column
    Table.clear_all

    Table.header("test header", :padding => 4, :justification => :left)
    Table.column('column 1', :width => 10, :padding => 2, :justification => :left)
    Table.column('column 2', :width => 10, :padding => 2, :justification => :left, :color => :blue)

    Table.row(["r1c1", "r1c2"])
    Table.row(["r2c1", {:data => "r2c1", :color => :red}])
    Table.row(["r3c1", "r3c2"])

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")

    assert_equal "+-------------------------+",           table_lines[0]
    assert_equal "|    test header          |",           table_lines[1]
    assert_equal "+-------------------------+",           table_lines[2]
    assert_equal "|  column 1  |  column 2  |",           table_lines[3]
    assert_equal "|------------+------------|",           table_lines[4]
    assert_equal "|  r1c1      |  #{"r1c2".blue}      |", table_lines[5]
    assert_equal "|  r2c1      |  #{"r2c1".red }      |", table_lines[6]
    assert_equal "|  r3c1      |  #{"r3c2".blue}      |", table_lines[7]
    assert_equal "+-------------------------+",           table_lines[8]
  end

  def test_color__whole_column__decimal
    Table.clear_all

    Table.header("test header", :padding => 4, :justification => :left)
    Table.column('column 1', :width => 10, :padding => 2, :justification => :left)
    Table.column('column 2', :width => 14, :padding => 2, :justification => :decimal, :color => :blue)

    Table.row(["r1c1", "r.1c2"])
    Table.row(["r2c1", "r2.c1"])
    Table.row(["r3c1", "r3c.2"])
    Table.row(["r3c1", ".r3c2"])

    out = capture_output do
      Table.tabulate
    end

    table_text = out.string
    table_lines = table_text.split("\n")

    assert_equal "+---------------------------+",     table_lines[0]
    assert_equal "|    test header            |",     table_lines[1]
    assert_equal "+---------------------------+",     table_lines[2]
    assert_equal "|  column 1  |   column 2   |",     table_lines[3]
    assert_equal "|------------+--------------|",     table_lines[4]
    assert_equal "|  r1c1      |\e[34m      r.1c2   \e[0m|", table_lines[5]
    assert_equal "|  r2c1      |\e[34m     r2.c1    \e[0m|", table_lines[6]
    assert_equal "|  r3c1      |\e[34m    r3c.2     \e[0m|", table_lines[7]
    assert_equal "|  r3c1      |\e[34m       .r3c2  \e[0m|", table_lines[8]
    assert_equal "+---------------------------+",     table_lines[9]
  end

  def test_string_output

    header_text = ['head A', 'head B', 'head C']
    header_width = [12, 10, 14]
    col_just = [:left, :right, :left]
    table_header = 'a table of stuff'

    Table.header(table_header, :padding => 4, :justification => :left)
    Table.header('second', :padding => 1, :justification => :right)

    (0..header_text.length - 1).each do |i|
      Table.column(header_text[i], :width => header_width[i], :padding => 2, :justification => col_just[i])
    end

    (1..5).each do |i|
      data = [i, (i+32).chr.to_s, i*i]
      Table.row(data)
    end

    Table.footer("this data is for practice", :padding => 1, :justification => :center)

    table_text = Table.tabulate_to_string

    table_lines = table_text.split("\n")
    assert_equal 14, table_lines.length, 'the number of lines in the table output'

    assert_equal '+--------------------------------------------+', table_lines[0]
    assert_equal '|    a table of stuff                        |', table_lines[1]
    assert_equal '|                                     second |', table_lines[2]
    assert_equal '+--------------------------------------------+', table_lines[3]
    assert_equal '|  head A      |    head B  |  head C        |', table_lines[4]
    assert_equal '|--------------+------------+----------------|', table_lines[5]
    assert_equal '|  1           |         !  |  1             |', table_lines[6]
    assert_equal '|  2           |         "  |  4             |', table_lines[7]
    assert_equal '|  3           |         #  |  9             |', table_lines[8]
    assert_equal '|  4           |         $  |  16            |', table_lines[9]
    assert_equal '|  5           |         %  |  25            |', table_lines[10]
    assert_equal '+--------------------------------------------+', table_lines[11]
    assert_equal '|         this data is for practice          |', table_lines[12]
    assert_equal '+--------------------------------------------+', table_lines[13]
  end

  def test_html_output

    header_text = ['a', 'b', 'c', 'd']

    table_header = 'header'

    Table.header(table_header, :padding => 4, :justification => :left)

    (0..header_text.length - 1).each do |i|
      Table.column(header_text[i])
    end

    Table.row([1, 2, 3, 4])
    Table.row([1.1, 2.1, 3.1, 4.1])

    table_text = Table.tabulate_to_html

    #assert_equal "booty", table_text

    table_lines = table_text.split("\n")
    assert_equal 25, table_lines.length, 'the number of lines in the table output'

    assert_equal '<table>',                              table_lines[0]
    assert_equal '<thead>',                              table_lines[1]
    assert_equal "<tr><th colspan='5'>header</th></tr>", table_lines[2]
    assert_equal '<tr>',                                 table_lines[3]
    assert_equal '<th>a</th>',                           table_lines[4]
    assert_equal '<th>b</th>',                           table_lines[5]
    assert_equal '<th>c</th>',                           table_lines[6]
    assert_equal '<th>d</th>',                           table_lines[7]
    assert_equal '</tr>',                                table_lines[8]
    assert_equal '</thead>',                             table_lines[9]
    assert_equal '<tbody>',                              table_lines[10]
    assert_equal '<tr>',                                 table_lines[11]
    assert_equal '<td>1</td>',                           table_lines[12]
    assert_equal '<td>2</td>',                           table_lines[13]
    assert_equal '<td>3</td>',                           table_lines[14]
    assert_equal '<td>4</td>',                           table_lines[15]
    assert_equal '</tr>',                                table_lines[16]
    assert_equal '<tr>',                                 table_lines[17]
    assert_equal '<td>1.1</td>',                         table_lines[18]
    assert_equal '<td>2.1</td>',                         table_lines[19]
    assert_equal '<td>3.1</td>',                         table_lines[20]
    assert_equal '<td>4.1</td>',                         table_lines[21]
    assert_equal '</tr>',                                table_lines[22]
    assert_equal '</tbody>',                             table_lines[23]
    assert_equal '</table>',                             table_lines[24]


  end


end
