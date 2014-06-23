require_relative 'test_helper'

class TestSpinner < Minitest::Test

  def test_spinner
    icons = %w(- \\ | /)

    spin_time = 0.5
    out = capture_output do
      Spinner.spin
      sleep spin_time
      Spinner.stop
    end

    s = out.string.clone
    ss = s.split("\b")

    assert_equal icons[0].strip, ss[0].strip
    assert_equal icons[1].strip, ss[1].strip
    assert_equal icons[2].strip, ss[2].strip
    assert_equal icons[3].strip, ss[3].strip

    spin_time = 0.2
    out = capture_output do
      Spinner.spin
      sleep spin_time
      Spinner.stop
    end

    s = out.string.clone
    ss = s.split("\b")
    assert_equal icons[0], ss[0]

  end

end