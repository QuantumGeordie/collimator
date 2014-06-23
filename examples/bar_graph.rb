#!/usr/bin/env ruby
require File.expand_path('../../lib/collimator', __FILE__)

include Collimator

colors = %w(red blue green cyan yellow magenta)

data = 10.times.map do |i|
  { :name => "data #{i}", :value => Random.rand(50), :color => colors[Random.rand(6)] }
end

puts 'Data with values displayed'
BarGraph.data = data
BarGraph.options = {:show_values => true}
BarGraph.plot

puts ''
puts 'Same Data without values displayed'
BarGraph.options = {:show_values => false}
BarGraph.plot