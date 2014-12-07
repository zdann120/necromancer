# coding: utf-8

module Necromancer
  module BooleanConverters
    # An object that converts a String to a Boolean
    class StringToBooleanConverter < Converter
      # Convert value to boolean type including range of strings
      #
      # @param [Object] value
      #
      # @example
      #   converter.call("True") # => true
      #
      #   other values converted to true are:
      #     1, t, T, TRUE,  true,  True,  y, Y, YES, yes, Yes, on, ON
      #
      # @example
      #   converter.call("False") # => false
      #
      #  other values coerced to false are:
      #    0, f, F, FALSE, false, False, n, N, NO,  no,  No, off, OFF
      #
      # @api public
      def call(value, options = {})
        strict = options.fetch(:strict, false)
        case value.to_s
        when /^(yes|y|on|t(rue)?|1)$/i
          return true
        when /^(no|n|off|f(alse)?|0)$/i
          return false
        else
          strict ? fail_conversion_type(value) : value
        end
      end
    end

    # An object that converts an Integer to a Boolean
    class IntegerToBooleanConverter < Converter
      # Convert integer to boolean
      #
      # @example
      #   converter.call(1)  # => true
      #
      # @example
      #   converter.call(0)  # => false
      #
      # @api public
      def call(value, options = {})
        strict = options.fetch(:strict, false)
        begin
          !value.zero?
        rescue
          strict ?  fail_conversion_type(value) : value
        end
      end
    end

    # An object that converts a Boolean to an Integer
    class BooleanToIntegerConverter < Converter
      # Convert boolean to integer
      #
      # @example
      #   converter.call(true)   # => 1
      #
      # @example
      #   converter.call(false)  # => 0
      #
      # @api public
      def call(value, options = {})
        value ? 1 : 0
      end
    end

    def self.load(conversions)
      conversions.register StringToBooleanConverter.new(:string, :boolean)
      conversions.register IntegerToBooleanConverter.new(:integer, :boolean)
      conversions.register BooleanToIntegerConverter.new(:boolean, :integer)
      conversions.register NullConverter.new(:boolean, :boolean)
    end
  end # BooleanConverters
end # Necromancer
