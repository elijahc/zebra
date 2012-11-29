require 'test/unit'
require '../zebra.rb'

class TestZebra < Test::Unit::TestCase

  def setup
    @rangetracker = Zebrascope.new(0,10)
  end

  def test_add
    @rangetracker.add( 5..7 )
    assert_equal( [ 5..7 ], @rangetracker.properties[:map] )
    @rangetracker.add( 1..3 )
    assert_equal( [1..3, 5..7 ], @rangetracker.properties[:map] )
  end

  def test_within_boundaries?
    assert( @rangetracker.within_boundaries?(5))
    assert( @rangetracker.within_boundaries?(0) )
    assert( @rangetracker.within_boundaries?(10) )
  end

  def test_stomps?
    @rangetracker.add( 3..7 )
    assert( @rangetracker.stomps?(5) )
    assert( @rangetracker.stomps?(1..5) )
    assert( @rangetracker.stomps?(5..9) )
  end

  def test_addable?
    assert( @rangetracker.addable?(5..7) )
    @rangetracker.add( 5..7 )
    assert_equal( false, @rangetracker.addable?(5) )
    assert_equal( false, @rangetracker.addable?(6) )
    assert_equal( false, @rangetracker.addable?(7) )
    assert_equal( false, @rangetracker.addable?(5..7) )

  end

end
