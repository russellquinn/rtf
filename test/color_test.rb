require 'test_helper'

# Color class unit test class.
class ColorTest < Test::Unit::TestCase
  def test_01
    colors = []
    colors.push(Color.new(255, 255, 255))
    colors.push(Color.new(200, 0, 0))
    colors.push(Color.new(0, 150, 0))
    colors.push(Color.new(0, 0, 100))
    colors.push(Color.new(0, 0, 0))

    assert_equal colors[0], colors[0]
    refute_equal colors[1], colors[2]
    assert_equal Color.new(0, 0, 100), colors[3]
    refute_equal 12345, colors[4]

    assert_equal 255, colors[0].red
    assert_equal 255, colors[0].green
    assert_equal 255, colors[0].blue

    assert_equal 200, colors[1].red
    assert_equal 0,   colors[1].green
    assert_equal 0,   colors[1].blue

    assert_equal 0,   colors[2].red
    assert_equal 150, colors[2].green
    assert_equal 0,   colors[2].blue

    assert_equal 0,   colors[3].red
    assert_equal 0,   colors[3].green
    assert_equal 100, colors[3].blue

    assert_equal 0,   colors[4].red
    assert_equal 0,   colors[4].green
    assert_equal 0,   colors[4].blue

    assert_equal '   Color (255/255/255)', colors[0].to_s(3)
    assert_equal '      Color (200/0/0)', colors[1].to_s(6)
    assert_equal 'Color (0/150/0)', colors[2].to_s(-20)
    assert_equal 'Color (0/0/100)', colors[3].to_s
    assert_equal 'Color (0/0/0)', colors[4].to_s

    assert_equal '  \red255\green255\blue255;', colors[0].to_rtf(2)
    assert_equal '    \red200\green0\blue0;', colors[1].to_rtf(4)
    assert_equal '\red0\green150\blue0;', colors[2].to_rtf(-6)
    assert_equal '\red0\green0\blue100;', colors[3].to_rtf
    assert_equal '\red0\green0\blue0;', colors[4].to_rtf
  end

  def test_red_out_of_range_raises_exception
    assert_raise RTFError do
      Color.new(256, 0, 0)
    end
  end

  def test_green_out_of_range_raises_exception
    assert_raise RTFError do
      Color.new(0, 1000, 0)
    end
  end

  def test_blue_out_of_range_raises_exception
    assert_raise RTFError do
      Color.new(0, 0, -300)
    end
  end

  def test_red_invalid_type_raises_exception
    assert_raise RTFError do
      Color.new('La la la', 0, 0)
    end
  end

  def test_green_invalid_type_raises_exception
    assert_raise RTFError do
      Color.new(0, {}, 0)
    end
  end

  def test_blue_invalid_type_raises_exception
    assert_raise RTFError do
      Color.new(0, 0, [])
    end
  end
end
