require 'test_helper'

# ColorTable class unit test class.
class ColorTableTest < Test::Unit::TestCase
  def setup
    @colors = [Color.new(0, 0, 0),
                Color.new(100, 100, 100),
                Color.new(150, 150, 150),
                Color.new(200, 200, 200),
                Color.new(250, 250, 250)]
  end

  def test_01
    tables = []
    tables.push(ColorTable.new)
    tables.push(ColorTable.new(@colors[0], @colors[2]))
    tables.push(ColorTable.new(*@colors))
    tables.push(ColorTable.new(@colors[0], @colors[1], @colors[0]))

    assert_equal 0, tables[0].size
    assert_equal 2, tables[1].size
    assert_equal 5, tables[2].size
    assert_equal 2, tables[3].size

    assert_nil   tables[0][0]
    assert_equal @colors[2], tables[1][1]
    assert_equal @colors[3], tables[2][3]
    assert_nil   tables[3][5]

    assert_equal nil, tables[0].index(@colors[1])
    assert_equal 2, tables[1].index(@colors[2])
    assert_equal 4, tables[2].index(@colors[3])
    assert_nil   tables[3].index(@colors[4])

    tables[0].add(@colors[0])
    assert_equal 1, tables[0].size
    assert_equal 1, tables[0].index(@colors[0])

    tables[0] << @colors[1]
    assert_equal 2, tables[0].size
    assert_equal 2, tables[0].index(@colors[1])

    tables[0].add(@colors[1])
    assert_equal 2, tables[0].size
    assert_equal [@colors[0], @colors[1]], [tables[0][0], tables[0][1]]

    tables[0] << @colors[0]
    assert_equal 2, tables[0].size
    assert_equal [@colors[0], @colors[1]], [tables[0][0], tables[0][1]]

    flags = [false, false, false, false, false]
    tables[2].each do |color|
      flags[@colors.index(color)] = !@colors.index(color).nil?
    end
    assert_nil flags.index(false)

    assert_equal "  Color Table (2 colors)\n"\
                 "     Color (0/0/0)\n"\
                 "     Color (100/100/100)",
                 tables[0].to_s(2)

    assert_equal "    Color Table (2 colors)\n"\
                 "       Color (0/0/0)\n"\
                 "       Color (150/150/150)",
                 tables[1].to_s(4)

    assert_equal "Color Table (5 colors)\n"\
                 "   Color (0/0/0)\n"\
                 "   Color (100/100/100)\n"\
                 "   Color (150/150/150)\n"\
                 "   Color (200/200/200)\n"\
                 "   Color (250/250/250)",
                 tables[2].to_s(-6)

    assert_equal "Color Table (2 colors)\n"\
                 "   Color (0/0/0)\n"\
                 "   Color (100/100/100)",
                 tables[3].to_s

    assert_equal "   {\\colortbl\n   ;\n"\
                 "   \\red0\\green0\\blue0;\n"\
                 "   \\red100\\green100\\blue100;\n"\
                 "   }",
                 tables[0].to_rtf(3)

    assert_equal "      {\\colortbl\n      ;\n"\
                 "      \\red0\\green0\\blue0;\n"\
                 "      \\red150\\green150\\blue150;\n"\
                 "      }",
                 tables[1].to_rtf(6)

    assert_equal "{\\colortbl\n;\n"\
                 "\\red0\\green0\\blue0;\n"\
                 "\\red100\\green100\\blue100;\n"\
                 "\\red150\\green150\\blue150;\n"\
                 "\\red200\\green200\\blue200;\n"\
                 "\\red250\\green250\\blue250;\n"\
                 "}",
                 tables[2].to_rtf(-9)

    assert_equal "{\\colortbl\n;\n"\
                 "\\red0\\green0\\blue0;\n"\
                 "\\red100\\green100\\blue100;\n"\
                 "}",
                 tables[3].to_rtf
  end
end
