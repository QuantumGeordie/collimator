require 'test/unit'
require File.expand_path('../../lib/collimator', __FILE__)
require 'stringio'
require 'date'

def capture_output
  out = StringIO.new
  $stdout = out
  yield
  return out
ensure
  $stdout = STDOUT
end