require 'pongo/abstract_particle'
require 'pongo/util/math_util'

module Pongo
  class RectangleParticle < AbstractParticle
    attr_accessor :extents, :axes, :radian 

    def initialize(x, y, width, height, options={})
      options = {:rotation => 0.0, :fixed => false, :mass => 1.0, :elasticity => 0.3, :friction => 0.0}.update(options)
      super(x, y, options[:fixed], options[:mass], options[:elasticity], options[:friction])
      @extents = [width/2.0, height/2.0]
      @axes = [Vector.new, Vector.new]
      self.radian = options[:rotation]
    end

    # The rotation of the RectangleParticle in radians. For drawing methods you may 
    # want to use the <code>angle</code> property which gives the rotation in
    # degrees from 0 to 360.
    # 
    # Note that while the RectangleParticle can be rotated, it does not have angular
    # velocity. In otherwords, during collisions, the rotation is not altered, 
    # and the energy of the rotation is not applied to other colliding particles.
    def radian=(rad)
      @radian = rad
      set_axes(rad)
    end

    # The rotation of the RectangleParticle in degrees. 
    def angle
      self.radian * MathUtil::ONE_EIGHTY_OVER_PI
    end
    alias degree angle

    def angle=(deg)
      self.radian = deg * MathUtil::PI_OVER_ONE_EIGHTY
    end
    alias degree= angle=

    def width=(w)
      @extents[0] = w / 2.0
    end

    def width
      @extents[0] * 2.0
    end

    def height=(h)
      @extents[1] = h / 2.0
    end

    def height
      @extents[1] * 2.0
    end

    def projection(axis)
      radius = 
        self.extents[0] * axis.dot(axes[0]).abs +
        self.extents[1] * axis.dot(axes[1]).abs

      c = @samp.dot(axis)

      @interval.min = c - radius
      @interval.max = c + radius
      @interval
    end
    alias get_projection projection

    def set_axes(rad)
      s = Math.sin(rad)
      c = Math.cos(rad)

      self.axes[0].x = c
      self.axes[0].y = s
      self.axes[1].x = -s
      self.axes[1].y = c
    end
    #alias axes= set_axes
  end
end
