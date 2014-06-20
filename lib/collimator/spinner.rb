module Collimator

  module Spinner
    @spinning = nil
    @icons = ['-', '\\', '|', '/']

    def self.spin
      @spinning = Thread.new(@icons) do |myIcons|
        i = 0
        while true do
          print myIcons[i]
          STDOUT.flush
          if i == myIcons.length - 1
            i = 0
          else
            i += 1
          end
          sleep 0.1

          print "\b"
          STDOUT.flush
        end
      end
    end

    def self.stop
      @spinning.exit
      print "\b"
      STDOUT.flush
    end
  end
end