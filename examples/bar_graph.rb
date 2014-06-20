#!/usr/bin/env ruby
require File.expand_path('../../lib/collimator', __FILE__)

include Collimator

data = 10.times.map do |i|
  { :name => "data #{i}", :value => Random.rand(50) }
end

BarGraph.data = data
BarGraph.options = {:show_values => true}
BarGraph.plot