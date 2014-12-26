require 'test_helper'

# Information class unit test class.
class TableNodeTest < Test::Unit::TestCase
  def setup
    @document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'))
    @colors  = []

    @colors << Color.new(200, 200, 200)
    @colors << Color.new(200, 0, 0)
    @colors << Color.new(0, 200, 0)
    @colors << Color.new(0, 0, 200)
  end

  def test_basics
    table = TableNode.new(@document, 3, 5, 10, 20, 30, 40, 50)

    assert_equal 3, table.rows
    assert_equal 5, table.columns
    assert_equal 3, table.size
    assert_equal 100, table.cell_margin
    assert_match /\\lastrow\n\\row$/, table.to_rtf
  end

  def test_mutators
    table = TableNode.new(@document, 3, 3)

    table.cell_margin = 250
    assert_equal 250, table.cell_margin
  end

  def test_coloring
    table = TableNode.new(@document, 3, 3)

    table.row_shading_color(1, @colors[0])
    assert_nil   table[0][0].shading_color
    assert_nil   table[0][1].shading_color
    assert_nil   table[0][2].shading_color
    assert_equal @colors[0], table[1][0].shading_color
    assert_equal @colors[0], table[1][1].shading_color
    assert_equal @colors[0], table[1][2].shading_color
    assert_nil   table[2][0].shading_color
    assert_nil   table[2][1].shading_color
    assert_nil   table[2][2].shading_color

    table.column_shading_color(2, @colors[1])
    assert_nil   table[0][0].shading_color
    assert_nil   table[0][1].shading_color
    assert_equal @colors[1], table[0][2].shading_color
    assert_equal @colors[0], table[1][0].shading_color
    assert_equal @colors[0], table[1][1].shading_color
    assert_equal @colors[1], table[1][2].shading_color
    assert_nil   table[2][0].shading_color
    assert_nil   table[2][1].shading_color
    assert_equal @colors[1], table[2][2].shading_color

    table.shading_color(@colors[2]) {|cell, x, y| x == y}
    assert_equal @colors[2], table[0][0].shading_color
    assert_nil   table[0][1].shading_color
    assert_equal @colors[1], table[0][2].shading_color
    assert_equal @colors[0], table[1][0].shading_color
    assert_equal @colors[2], table[1][1].shading_color
    assert_equal @colors[1], table[1][2].shading_color
    assert_nil   table[2][0].shading_color
    assert_nil   table[2][1].shading_color
    assert_equal @colors[2], table[2][2].shading_color
  end

  def test_border_width
    table = TableNode.new(@document, 2, 2)

    table.border_width = 5
    assert_equal [5, 5, 5, 5], table[0][0].border_widths
    assert_equal [5, 5, 5, 5], table[0][1].border_widths
    assert_equal [5, 5, 5, 5], table[1][0].border_widths
    assert_equal [5, 5, 5, 5], table[1][1].border_widths

    table.border_width = 0
    assert_equal [0, 0, 0, 0], table[0][0].border_widths
    assert_equal [0, 0, 0, 0], table[0][1].border_widths
    assert_equal [0, 0, 0, 0], table[1][0].border_widths
    assert_equal [0, 0, 0, 0], table[1][1].border_widths
  end
end
