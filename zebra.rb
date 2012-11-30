class Uberange < Range

  def intersects?(range)
    case range
    when Range
      return ( self.include?(range.last) && !self.include?(range.first) ) || ( self.include?(range.first) && !self.include?(range.last))
    when Fixnum
      return false
    else
      raise "Cannot respond to class of #{range.class.to_s}"
    end
  end

  def borders?(range)
    borders_left?(range) || borders_right?(range)
  end

  def borders_right?(value)
    case value
    when Range
      return self.last + 1 == value.first
    when Fixnum
      return self.last + 1 == value
    else
      super
    end
  end

  def borders_left?(value)
    case value
    when Range
      return value.last + 1 == self.first
    when Fixnum
      return value + 1 == self.first
    else
      super
    end
  end

  def add(range)
    if borders_left?(range)
      return Uberange.new( range.first, self.last)
    elsif borders_right?(range)
      return Uberange.new( self.first, range.last )
    else
      raise 'This range does not border your range'
    end
  end

  def <=>(range)
    self.first.<=>(range.first)
  end

  def include?(range)
    case range
    when Range
      return super(range.last) && super(range.first)
    else
      super
    end
  end

end

class Zebrascope

  def initialize(startpoint, endpoint)
    @range = Uberange.new(startpoint, endpoint)
    @rangemap = Array.new
  end

  def consolidate!
    if @rangemap.length > 1
      tmp = Array.new
      nextval = nil
      currentval = @rangemap.shift
      @rangemap.length.times do
        nextval = @rangemap.shift
        if (nextval.first - currentval.last) == 1
          nextval = Uberange.new(currentval.first, nextval.last)
          currentval = nextval
        else
          tmp << currentval
          currentval = nextval
        end
      end
      tmp << nextval
      @rangemap = tmp
    end
    @rangemap
  end

  def properties
    {:map => @rangemap, :boundaries => @range }
  end

  def within_boundaries?(value)
    @range.include?(value) && !@range.intersects?(value)
  end

  def stomps?(value)
    !@rangemap.select{ |r| r.include?(value) || r.intersects?(value) }.empty?
  end

  def addable?(value)
    # If I tried to add this value, would it be inserted?
    if !within_boundaries?(value)
      message = 'Invalid, out of bounds'
      addable = false
    elsif stomps?(value)
      message = 'Invalid, already exists'
      addable = false
    else
      message = 'Valid'
      addable = true
    end
    return { 'message' => message, 'addable' => addable, 'next' => next_available(value) }
  end

  def next_available(value)
    @rangemap.each do |v|
      if v.include?(value)
        return v.last + 1
      else
        return nil
      end
    end
  end

  def add(value)
    # Make sure the added range doesn't stomp on an existing range
    raise 'Cannot add, outside of range' if !within_boundaries?(value)
    raise 'Cannot add, intersects a range already present' if stomps?(value)

    # Must be able to add the value, so add it
    case value
    when Range
      @rangemap << Uberange.new(value.first, value.last)
    when Fixnum
      @rangemap << Uberange.new(value, value)
    end

    # Sort rangemap
    @rangemap = @rangemap.sort
    self.consolidate!

  end

end
