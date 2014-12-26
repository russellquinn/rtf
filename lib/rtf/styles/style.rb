module RTF
  # This is a parent class that all style classes will derive from.
  class Style
    # A definition for a character flow setting.
    LEFT_TO_RIGHT = :rtl

    # A definition for a character flow setting.
    RIGHT_TO_LEFT = :ltr

    # This method retrieves the command prefix text associated with a Style
    # object. This method always returns nil and should be overridden by
    # derived classes as needed.
    #
    # ==== Parameters
    # fonts::    A reference to the document fonts table. May be nil if no
    #            fonts are used.
    # colors::  A reference to the document color table. May be nil if no
    #            colors are used.
    def prefix(fonts, colors)
      nil
    end

    # This method retrieves the command suffix text associated with a Style
    # object. This method always returns nil and should be overridden by
    # derived classes as needed.
    #
    # ==== Parameters
    # fonts::    A reference to the document fonts table. May be nil if no
    #            fonts are used.
    # colors::  A reference to the document color table. May be nil if no
    #            colors are used.
    def suffix(fonts, colors)
      nil
    end

    # Used to determine if the style applies to characters. This method always
    # returns false and should be overridden by derived classes as needed.
    def is_character_style?
      false
    end

    # Used to determine if the style applies to paragraphs. This method always
    # returns false and should be overridden by derived classes as needed.
    def is_paragraph_style?
      false
    end

    # Used to determine if the style applies to documents. This method always
    # returns false and should be overridden by derived classes as needed.
    def is_document_style?
      false
    end

    # Used to determine if the style applies to tables. This method always
    # returns false and should be overridden by derived classes as needed.
    def is_table_style?
      false
    end
  end
end