require_relative 'test_helper'

class TestSpinner < Minitest::Test
  include Collimator

  def teardown
    $stdout = STDOUT
  end

  def test_spinner
    spin_time = 1
    out = capture_output do
      Spinner.spin
      sleep spin_time
      Spinner.stop
    end

    length_should_be = (spin_time / 0.1) * 2
    s = out.string.clone
    assert_equal length_should_be, s.length

    spin_time = 0.2
    out = capture_output do
      Spinner.spin
      sleep spin_time
      Spinner.stop
    end

    length_should_be = (spin_time / 0.1) * 2
    s = out.string.clone
    assert_equal length_should_be, s.length
  end

end