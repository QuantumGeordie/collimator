# Collimator

a little gem for making simple formatted tables of data in a command line ruby script/gem/app.

## Travis-ci.org

[![Build Status](https://travis-ci.org/QuantumGeordie/collimator.png?branch=master)](https://travis-ci.org/QuantumGeordie/collimator)

## Installation

Add this line to your application's Gemfile:

    gem 'collimator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install collimator

## Usage

### Table
see a few samples in `examples`.

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

will result in...

    +---------------------------------------------------------------+
    |                          Collimator                           |
    |                         Usage Example                         |
    |                   Can have lots of headers                    |
    +---------------------------------------------------------------+
    |                    |   numbers    |  words       |  decimal   |
    |--------------------+--------------+--------------+------------|
    |            george  |     123      |  holla       |    12.5    |
    |               jim  |      8       |  hi          |    76.58   |
    |            robert  |    10000     |  greetings   |     0.2    |
    +---------------------------------------------------------------+
    |                         gotta love it                         |
    +---------------------------------------------------------------+

### Spinner

    Spinner.spin
    # ...
    Spinner.stop

### Progress Bar

    ProgressBar.start({:min => 0, :max => 100, :method => :percent, :step_size => 10})

    0.upto(10) do
      # ...
      ProgressBar.increment
    end

    ProgressBar.complete


Better usage coming. in the mean time, tests might show best how to use.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
