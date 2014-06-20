require_relative 'test_helper'

class TestBarGraph < Minitest::Test
  def setup
    BarGraph.clear_all
  end

  def test_bar_graph__data_set
    assert_equal [], BarGraph.data, 'should start with an empty data set'

    BarGraph.data = [ {:value => 10, :name => 'value 1'}, {:name => 'value 2', :value => 4} ]

    assert_equal [ {:value => 10, :name => 'value 1'}, {:name => 'value 2', :value => 4} ], BarGraph.data

    BarGraph.data = {:name => 'extra', :value => 101}

    assert_equal [ {:value => 10, :name => 'value 1'}, {:name => 'value 2', :value => 4}, {:name => 'extra', :value => 101} ], BarGraph.data

    BarGraph.clear_data

    assert_equal [], BarGraph.data, 'should start with an empty data set'
  end

  def test_bar_graph__simple_plot

    data = []
    data << {:name => 'USA', :value => 10}
    data << {:name => 'Holland', :value => 14}
    data << {:name => 'Spain', :value => 7}
    data << {:name => 'Germany', :value => 12}

    BarGraph.data = data

    out = capture_output do
      BarGraph.plot
    end

    plot_text = out.string
    plot_lines = plot_text.split("\n")
    assert_equal 4, plot_lines.length, 'simple plot size in number of lines'

  end

end