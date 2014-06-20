module Collimator
  module BarGraph

    @bar_character = "\u2588"
    @data = []
    @options = {}

    def self.clear_all
      @bar_character = "\u2588"
      @data = []
      @options = {}
    end

    def self.clear_data
      @data = []
    end

    def self.data=(data)
      if data.is_a?(Array)
        @data = data
      elsif data.is_a?(Hash)
        @data << data
      end
    end

    def self.data
      @data
    end

    def self.options
      @options
    end

    def self.options=(options)
      @options.merge!(options)
    end

    def self.plot(options = {})
      self.options = options
      header_width = max_header_length

      @data.each do |data|
        value = data[:value].to_i
        header = data[:name].ljust(header_width)
        bar = @bar_character * value
        bar = bar.cyan

        value = @options[:show_values] ? "#{value.to_s.rjust(3)}" : ''
        full_output = "  #{header} #{value} #{bar}"

        puts full_output
      end

    end

    private

    def self.max_header_length
      @data.map { |data| data[:name].length }.max
    end

  end
end