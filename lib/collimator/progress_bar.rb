module Collimator
  module ProgressBar
    @display_width = 100
    @max = 100
    @min = 0
    @method = :percent
    @step_size = 5
    @current = 0

    def self.set_parameters(params)
      @display_width = params[:display_width] if params.has_key?(:display_width)
      @max = params[:max] if params.has_key?(:max)
      @min = params[:min] if params.has_key?(:min)
      @method = params[:method] if params.has_key?(:method)
      @step_size = params[:step_size] if params.has_key?(:step_size)
    end

    def self.start(params = {})
      set_parameters params
      @current = @min
      put_current_progress
    end

    def self.increment
      @current += @step_size
      put_current_progress unless @current > @max
    end

    def self.complete
      clear
      puts " "*(@display_width + 2)
    end

    def self.clear
      print "\b"*(@display_width + 2)
    end

    private

    def self.put_current_progress
      clear
      STDOUT.flush
      print build_bar_string
      #puts build_bar_string
    end

    def self.build_bar_string
      units = @max - @min
      unit_width = @display_width/units
      percent_complete = @current / (units * 1.0)

      s = '-'*(percent_complete * @display_width) + ' '*((100-percent_complete) * @display_width)
      s1 = s[0..(@display_width/2 - 4)]
      s2 = s[(@display_width/2 + 3)..(@display_width - 1)]

      formatted_percent = "%0.1f" % (percent_complete * 100)

      s = '|' + s1 + "#{formatted_percent}%".center(6) + s2 + '|'
      #s = "#{units} - #{unit_width} - #{percent_complete} - #{@current}"
    end
  end
end
