module RTF
  class RTFError < StandardError
    def initialize(message=nil)
      super(message || 'No error message available.')
    end
  end
end