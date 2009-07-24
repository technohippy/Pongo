require 'pongo/abstract_particle'

module Pongo
  class RectangleParticle < AbstractParticle
    attr_accessor :extents, :axes, :radian 

    def initialize(x, y, width, height, rotation=0, fixed=false, mass=1, elasticity=0.3, friction=0)
      super(x, y, fixed, mass, elasticity, friction)
      @extents = [width/2, height/2]
      @axes = [Vector.new, Vector.new]
      self.radian = rotation
    end

    # The rotation of the RectangleParticle in radians. For drawing methods you may 
    # want to use the <code>angle</code> property which gives the rotation in
    # degrees from 0 to 360.
    # 
    # <p>
    # Note that while the RectangleParticle can be rotated, it does not have angular
    # velocity. In otherwords, during collisions, the rotation is not altered, 
    # and the energy of the rotation is not applied to other colliding particles.
    # </p>
    def radian=(t)
      @radian = t
      set_axes(t)
    end

    def angle
      @radian * MathUtil::ONE_EIGHTY_OVER_PI
    end

    def angle=(a)
      @radian = a * MathUtil::PI_OVER_ONE_EIGHTY
    end

    def width=(w)
      @extents[0] = w / 2
    end

    def width
      @extents[0] * 2
    end

    def height=(h)
      @extents[1] = h / 2
    end

    def height
      @extents[1] * 2
    end

    def get_projection(axis)
      radius = 
        @extents[0] * axis.dot(axes[0]).abs +
        @extents[1] * axis.dot(axes[1]).abs

      c = @samp.dot(axis)

      @interval.min = c - radius
      @interval.max = c + radius
      @interval
    end
    alias projection get_projection

    def set_axes(t)
      s = Math.sin(t)
      c = Math.cos(t)

      @axes[0].x = c
      @axes[0].y = s
      @axes[1].x = -s
      @axes[1].y = c
    end
    alias axes= set_axes
  end
end
