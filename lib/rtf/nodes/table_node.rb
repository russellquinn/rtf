require 'stringio'

module RTF
  # This class represents a table node within an RTF document. Table nodes are
  # specialised container nodes that contain only TableRowNodes and have their
  # size specified when they are created an cannot be resized after that.
  class TableNode < ContainerNode
    # Cell margin. Default to 100
    attr_accessor :cell_margin

    # This is a constructor for the TableNode class.
    #
    # ==== Parameters
    # parent::   A reference to the node that owns the table.
    # rows::     The number of rows in the tabkle.
    # columns::  The number of columns in the table.
    # *widths::  One or more integers specifying the widths of the table
    #            columns.
    def initialize(parent, *args, &block)
      if args.size>=2
        rows=args.shift
        columns=args.shift
        widths=args
        super(parent) do
          children = []
          rows.times {children.push(TableRowNode.new(self, columns, *widths))}
          children
        end

      elsif block
        block.arity<1 ? self.instance_eval(&block) : block.call(self)
      else
        raise "You should use 0 or >2 args"
      end
      @cell_margin = 100
    end

    # Attribute accessor.
    def rows
      children.size
    end

    # Attribute accessor.
    def columns
      children[0].length
    end

    # This method assigns a border width setting to all of the sides on all
    # of the cells within a table.
    #
    # ==== Parameters
    # width::  The border width setting to apply. Negative values are ignored
    #          and zero switches the border off.
    def border_width=(width)
      self.each {|row| row.border_width = width}
    end

    # This method assigns a shading color to a specified row within a
    # TableNode object.
    #
    # ==== Parameters
    # index::   The offset from the first row of the row to have shading
    #           applied to it.
    # color::  A reference to a Color object representing the shading color
    #           to be used. Set to nil to clear shading.
    def row_shading_color(index, color)
      row = self[index]
      row.shading_color = color if row != nil
    end

    # This method assigns a shading color to a specified column within a
    # TableNode object.
    #
    # ==== Parameters
    # index::   The offset from the first column of the column to have shading
    #           applied to it.
    # color::  A reference to a Color object representing the shading color
    #           to be used. Set to nil to clear shading.
    def column_shading_color(index, color)
      self.each do |row|
        cell = row[index]
        cell.shading_color = color if cell != nil
      end
    end

    # This method provides a means of assigning a shading color to a
    # selection of cells within a table. The method accepts a block that
    # takes three parameters - a TableCellNode representing a cell within the
    # table, an integer representing the x offset of the cell and an integer
    # representing the y offset of the cell. If the block returns true then
    # shading will be applied to the cell.
    #
    # ==== Parameters
    # color::  A reference to a Color object representing the shading color
    #           to be applied. Set to nil to remove shading.
    def shading_color(color)
      if block_given?
        0.upto(self.size - 1) do |x|
          row = self[x]
          0.upto(row.size - 1) do |y|
            apply = yield row[y], x, y
            row[y].shading_color = color if apply
          end
        end
      end
    end

    # This method overloads the store method inherited from the ContainerNode
    # class to forbid addition of further nodes.
    #
    # ==== Parameters
    # node::  A reference to the node to be added.
    def store(node)
      raise RTF::RTFError, 'Table nodes cannot have nodes added to them.'
    end

    # This method generates the RTF document text for a TableCellNode object.
    def to_rtf
      text = StringIO.new
      size = 0

      self.each do |row|
        if size > 0
          text << "\n"
        else
          size = 1
        end
        text << row.to_rtf
      end

      text.string.sub(/\\row(?!.*\\row)/m, "\\lastrow\n\\row")
    end

    alias :column_shading_color :column_shading_color
    alias :row_shading_color :row_shading_color
    alias :shading_color :shading_color
  end
end