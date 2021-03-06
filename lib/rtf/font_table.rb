module RTF
  # This class represents the font table for an RTF document. An instance of
  # the class is used internally by the Document class and should not need to
  # be explicitly instantiated (although it can be obtained from a Document
  # object if needed).
  class FontTable
    extend Forwardable
    def_delegators :@fonts, :size, :each, :[], :index

    # This is the constructor for the RTFTable class.
    #
    # ==== Parameters
    # *fonts::  Zero or more font objects that are to be added to the font
    #           table. Objects that are not Fonts will be ignored.
    def initialize(*fonts)
      @fonts = []
      fonts.each {|font| add(font)}
    end

    # This method adds a font to a FontTable instance. This method returns
    # a reference to the FontTable object updated.
    #
    # ==== Parameters
    # font::  A reference to the font to be added. If this is not a Font
    #         object or already exists in the table it will be ignored.
    def add(font)
      if font.instance_of?(Font)
        @fonts.push(font) if @fonts.index(font).nil?
      end
      self
    end

    # This method generates a textual description for a FontTable object.
    #
    # ==== Parameters
    # indent::  The number of spaces to prefix to the lines generated by the
    #           method. Defaults to zero.
    def to_s(indent=0)
      prefix = indent > 0 ? ' ' * indent : ''
      text   = StringIO.new
      text << "#{prefix}Font Table (#{@fonts.size} fonts)"
      @fonts.each {|font| text << "\n#{prefix}   #{font}"}
      text.string
    end

    # This method generates the RTF text for a FontTable object.
    #
    # ==== Parameters
    # indent::  The number of spaces to prefix to the lines generated by the
    #           method. Defaults to zero.
    def to_rtf(indent=0)
      prefix = indent > 0 ? ' ' * indent : ''
      text   = StringIO.new
      text << "#{prefix}{\\fonttbl"
      @fonts.each_index do |index|
        text << "\n#{prefix}{\\f#{index}#{@fonts[index].to_rtf}}"
      end
      text << "\n#{prefix}}"
      text.string
    end

    alias << add
  end
end