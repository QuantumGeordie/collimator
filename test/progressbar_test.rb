require_relative 'test_helper'

class TestProgressBar < Minitest::Test
  include Collimator

  def teardown
    $stdout = STDOUT
  end

  def test_progress
    out = capture_output do
      ProgressBar.start({:min => 0, :max => 100, :method => :percent, :step_size => 1})
    end

    s = out.string.clone
    assert_equal 102, s.count("\b")

    s.gsub!("\b", "")
    assert_equal "|                                                0.0%                                                |", s
    assert_equal s.length, 102

    out = capture_output do
      ProgressBar.increment
    end

    s = out.string.clone
    s.gsub!("\b", "")
    assert_equal "|-                                               1.0%                                                |", s

    5.times do
      out = capture_output do
        ProgressBar.increment
      end
    end

    out = capture_output do
      ProgressBar.increment
    end

    s = out.string.clone
    s.gsub!("\b", "")
    assert_equal "|-------                                         7.0%                                                |", s

    75.times do
      out = capture_output do
        ProgressBar.increment
      end
    end

    out = capture_output do
      ProgressBar.increment
    end

    s = out.string.clone
    s.gsub!("\b", "")
    assert_equal "|-----------------------------------------------83.0% ------------------------------                 |", s

  end

  def test_completion
    out = capture_output do
      ProgressBar.start({:min => 0, :max => 100, :method => :percent, :step_size => 10})
    end

    5.times do
      out = capture_output do
        ProgressBar.increment
      end
    end

    out = capture_output do
      ProgressBar.increment
    end
    s = out.string.clone
    s.gsub!("\b", "")
    assert_equal "|-----------------------------------------------60.0% -------                                        |", s

    out = capture_output do
      ProgressBar.complete
    end

    s = out.string.clone
    s.gsub!("\b", "")
    assert_equal "                                                                                                      \n", s

  end
end