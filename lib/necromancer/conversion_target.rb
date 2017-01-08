# coding: utf-8

module Necromancer
  # A class responsible for wrapping conversion target
  #
  # @api private
  class ConversionTarget
    # Used as a stand in for lack of value
    # @api private
    UndefinedValue = Module.new

    # @api private
    def initialize(conversions, object)
      @object = object
      @conversions = conversions
    end

    # @api private
    def self.for(context, value, block)
      if UndefinedValue.equal?(value)
        unless block
          fail ArgumentError,
               'You need to pass either argument or a block to `convert`.'
        end
        new(context, block.call)
      elsif block
        fail ArgumentError,
             'You cannot pass both an argument and a block to `convert`.'
      else
        new(context, value)
      end
    end

    # Allows to specify conversion source type
    #
    # @example
    #   converter.convert('1').from(:string).to(:numeric)  # => 1
    #
    # @return [ConversionType]
    #
    # @api public
    def from(source)
      @source = source
      self
    end

    # Runs a given conversion
    #
    # @example
    #   converter.convert('1').to(:numeric)  # => 1
    #
    # @return [Object]
    #   the converted target type
    #
    # @api public
    def to(target, options = {})
      conversion = conversions[source || detect(object, false), detect(target)]
      conversion.call(object, options)
    end

    # Inspect this conversion
    #
    # @api public
    def inspect
      %(#<#{self.class}@#{object_id} @object=#{object}, @source=#{detect(object)}>)
    end

    protected

    # Detect object type
    #
    # @api private
    def detect(object, symbol_as_object = true)
      case object
      when TrueClass, FalseClass then :boolean
      # when Fixnum, Bignum then :integer
      else
        if object.is_a?(Symbol) && symbol_as_object
          object
        else
          object.class.name.downcase
        end
      end
    end

    attr_reader :object

    attr_reader :conversions

    attr_reader :source
  end # ConversionTarget
end # Necromancer
