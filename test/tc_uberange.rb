require 'test/unit'
require '../zebra.rb'

class TestUberange < Test::Unit::TestCase

  def setup
    @uberange = Uberange.new(0,10)
  end

  def test_include?
    assert_equal(true,  @uberange.include?(5))
    assert_equal(true,  @uberange.include?(2..9))
    assert_equal(false, @uberange.include?(-1..6))
    assert_equal(false, @uberange.include?(5..11))
  end

  def test_intersects?
    assert_equal( true,  @uberange.intersects?(-1..3) )
    assert_equal( true,  @uberange.intersects?(5..11) )
    assert_equal( false, @uberange.intersects?(3..10) )
    assert_equal( false, @uberange.intersects?(3) )
  end

  def test_borders?
    assert_equal( true,  @uberange.borders?(11..15) )
    assert_equal( true,  @uberange.borders?(-5..-1) )
    assert_equal( true,  @uberange.borders?(11) )
    assert_equal( true,  @uberange.borders?(-1) )
    assert_equal( false, @uberange.borders?(1..9) )
    assert_equal( false, @uberange.borders?(0) )
    assert_equal( false, @uberange.borders?(10) )
    assert_equal( false, @uberange.borders?(9) )
    assert_equal( false, @uberange.borders?(1) )
    assert_equal( false, @uberange.borders?(12..15) )
  end

end
