require 'pongo/abstract_particle'

module Pongo
  class CircleParticle < AbstractParticle
    attr_accessor :radius

    def initialize(x, y, radius, fixed=false, mass=1, elasticity=0.3, friction=0)
      super(x, y, fixed, mass, elasticity, friction)
      @radius = radius
    end

    def get_projection(axis)
      c = @samp.dot(axis)
      @interval.min = c - @radius
      @interval.max = c + @radius
      @interval
    end
    alias projection get_projection

    def get_interval_x
      @interval.min = @samp.x - @radius
      @interval.max = @samp.x + @radius
      @interval
    end
    alias interval_x get_interval_x

    def get_interval_y
      @interval.min = @samp.y - @radius
      @interval.max = @samp.y + @radius
      @interval
    end
    alias interval_y get_interval_y
  end
end
