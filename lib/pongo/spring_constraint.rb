require 'pongo/abstract_constraint'
require 'pongo/spring_constraint_particle'
require 'pongo/util/math_util'

module Pongo
  class SpringConstraint < AbstractConstraint
    attr_accessor :p1, :p2, :rest_length, :collidable, :scp

    def initialize(p1, p2, options={})
      options = {:stiffness => 0.5, :collidable => false, :rect_height => 1, :rect_scale => 1, :scale_to_length => false}.update(options)
      super(options[:stiffness])
      @p1 = p1
      @p2 = p2
      check_particles_location
      @rest_length = curr_length
      set_collidable(options[:collidable], options[:rect_height], options[:rect_scale], options[:scale_to_length])
    end

    def radian
      d = delta
      Math.atan2(d.y, d.x)
    end

    def angle
      radian * MathUtil::ONE_EIGHTY_OVER_PI
    end

    def center
      (@p1.curr + @p2.curr) / 2
    end

    def rect_scale=(s)
      if @scp
        @scp.rect_scale = s
      end
    end

    def rect_scale
      @scp.rect_scale
    end

    def curr_length
      @p1.curr.distance(@p2.curr)
    end

    def rect_height
      @scp.rect_height
    end

    def rect_height=(h)
      if @scp
        @scp.rect_height = h
      end
    end

    def rest_length=(r)
      raise ArgumentError.new('restLength must be greater than 0') if r <= 0
      @rest_length = r
    end

    def collidable?
      @collidable
    end

    def fixed_end_limit
      @scp.fixed_end_limit
    end

    def fixed_end_limit=(f)
      if @scp
        @scp.fixed_end_limit = f
      end
    end

    def set_collidable(b, rect_height, rect_scale, scale_to_length)
      if @collidable = b
        @scp = SpringConstraintParticle.new(@p1, @p2, self, rect_height, rect_scale, scale_to_length)
      else
        @scp = nil
      end
    end

    def is_connected_to?(p)
      [@p1, @p2].include? p
    end

    def fixed
      @p1.fixed? and @p2.fixed?
    end
    alias fixed? fixed

    def init
      cleanup
      if collidable?
        @scp.init
      else
        init_display
      end
      draw
    end

    def resolve
      return if fixed?

      delta_length = curr_length
      diff = (delta_length - rest_length) / 
        (delta_length * (@p1.inv_mass + @p2.inv_mass))
      dmds = delta * (diff * stiffness)

      @p1.curr.minus!(dmds * @p1.inv_mass)
      @p2.curr.plus!( dmds * @p2.inv_mass)
    end

    def init_display
      #raise NotImplementedError
    end

    def delta
      @p1.curr - @p2.curr
    end

    def check_particles_location
      if @p1.curr.x == @p2.curr.x and @p1.curr.y == @p2.curr.y
        @p2.curr.x += 0.0001
      end
    end
  end
end
