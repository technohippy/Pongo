module Pongo
  class Vector
    attr_accessor :x, :y
    
    def initialize(px=0, py=0)
      set_to(px, py)
    end

    def set_to(px, py=nil)
      @x, @y = py ? [px, py] : [px.x, px.y]
      self
    end

    def copy(v)
      set_to(v.x, v.y)
    end

    def dup
      Vector.new(@x, @y)
    end

    def dot(v)
      @x * v.x + @y * v.y
    end

    def cross(v)
      @x * v.y - @y * v.x
    end

    def plus(v)
      Vector.new(@x + v.x, @y + v.y)
    end
    alias + plus

    def plus_equals(v)
      @x += v.x
      @y += v.y
      self
    end
    alias plus! plus_equals

    def minus(v)
      Vector.new(@x - v.x, @y - v.y)
    end
    alias - minus

    def minus_equals(v)
      @x -= v.x
      @y -= v.y
      self
    end
    alias minus! minus_equals

    def mult(s)
      Vector.new(@x * s, @y * s)
    end

    def mult_equals(s)
      @x *= s
      @y *= s
      self
    end
    alias mult! mult_equals

    def times(v)
      Vector.new(x * v.x, y * v.y)
    end

    def *(s_or_v)
      if s_or_v.is_a? Vector
        times(s_or_v)
      else
        mult(s_or_v)
      end
    end

    def div(s)
      s = 0.0001 if s == 0
      Vector.new(@x / s, @y / s)
    end
    alias / div

    def div_equals(s)
      s = 0.0001 if s == 0
      @x /= s
      @y /= s
      self
    end
    alias div! div_equals

    def magnitude
      Math.sqrt(@x * @x + @y * @y)
    end

    def distance(v)
      minus(v).magnitude
    end

    def normalize
      if @x == 0 and @y == 0
        mult(1000.0)
      else
        mult(1.0 / magnitude)
      end
    end

    def normalize!
      unless @x == 0 and @y == 0
        mult!(1.0 / magnitude)
      end
      self
    end

    def to_s
      "#{@x} : #{y}"
    end
  end
end
