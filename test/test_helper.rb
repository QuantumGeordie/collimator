require 'minitest/autorun'
require 'minitest/reporters'

require File.expand_path('../../lib/collimator', __FILE__)
require 'stringio'
require 'date'

Minitest::Reporters.use!
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(:color => true)]

def capture_output
  out = StringIO.new
  $stdout = out
  yield
  return out
ensure
  $stdout = STDOUT
end