#!/usr/bin/env ruby
require "rubygems"
require 'collimator'

include Collimator

ProgressBar.start({:min => 0, :max => 100, :method => :percent, :step_size => 10})
0.upto(10) do
  sleep 0.5
  ProgressBar.increment
end

sleep 0.5
ProgressBar.complete
