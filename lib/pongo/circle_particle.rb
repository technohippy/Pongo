require 'pongo/abstract_particle'

module Pongo
  # A circle shaped particle. 	 
  class CircleParticle < AbstractParticle
    attr_accessor :radius

    def initialize(x, y, radius, options={})
      options = {:fixed => false, :mass => 1, :elasticity => 0.3, :friction => 0}.update(options)
      super(x, y, options[:fixed], options[:mass], options[:elasticity], options[:friction])
      @radius = radius
    end

    def projection(axis)
      c = @samp.dot(axis)
      @interval.min = c - @radius
      @interval.max = c + @radius
      @interval
    end
    alias get_projection projection

    def interval_x
      @interval.min = @samp.x - @radius
      @interval.max = @samp.x + @radius
      @interval
    end
    alias get_interval_x interval_x

    def interval_y
      @interval.min = @samp.y - @radius
      @interval.max = @samp.y + @radius
      @interval
    end
    alias get_interval_y interval_y
  end
end
