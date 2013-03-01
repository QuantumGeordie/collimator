#!/usr/bin/env ruby
require "rubygems"
require 'collimator'

include Collimator

Table.header("Collimator")
Table.header("Usage Example")
Table.header("Can have lots of headers")

Table.column('',        :width => 18, :padding => 2, :justification => :right)
Table.column('numbers', :width => 14, :justification => :center)
Table.column('words',   :width => 12, :justification => :left, :padding => 2)
Table.column('decimal', :width => 12, :justification => :decimal)

Table.row(['george', 123, 'holla', 12.5])
Table.row(['jim', 8, 'hi', 76.58])
Table.row(['robert', 10000, 'greetings', 0.2])

Table.footer("gotta love it", :justification => :center)

Table.tabulate
