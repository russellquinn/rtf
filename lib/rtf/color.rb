require 'stringio'

module RTF
  # This class represents a color within a RTF document.
  class Color
    # Attribute accessor.
    attr_reader :red, :green, :blue


    # This is the constructor for the Color class.
    #
    # ==== Parameters
    # red::    The intensity setting for red in the color. Must be an
    #          integer between 0 and 255.
    # green::  The intensity setting for green in the color. Must be an
    #          integer between 0 and 255.
    # blue::   The intensity setting for blue in the color. Must be an
    #          integer between 0 and 255.
    #
    # ==== Exceptions
    # RTFError::  Generated whenever an invalid intensity setting is
    #             specified for the red, green or blue values.
    def initialize(red, green, blue)
      %w(red green blue).each do |name|
        color = eval(name)
        if !color.kind_of?(Integer) || !(0..255).include?(color)
          raise RTF::RTFError, "Invalid #{name} intensity setting '#{color}' specified for a Color object."
        end
      end

      @red   = red
      @green = green
      @blue  = blue
    end

    # This method overloads the comparison operator for the Color class.
    #
    # ==== Parameters
    # object::  A reference to the object to be compared with.
    def ==(object)
      object.instance_of?(Color) and
      object.red   == @red and
      object.green == @green and
      object.blue  == @blue
    end

    # This method returns a textual description for a Color object.
    #
    # ==== Parameters
    # indent::  The number of spaces to prefix to the lines created by the
    #           method. Defaults to zero.
    def to_s(indent=0)
      prefix = indent > 0 ? ' ' * indent : ''
      "#{prefix}Color (#{@red}/#{@green}/#{@blue})"
    end

    # This method generates the RTF text for a Color object.
    #
    # ==== Parameters
    # indent::  The number of spaces to prefix to the lines created by the
    #           method. Defaults to zero.
    def to_rtf(indent=0)
      prefix = indent > 0 ? ' ' * indent : ''
      "#{prefix}\\red#{@red}\\green#{@green}\\blue#{@blue};"
    end
  end
end
