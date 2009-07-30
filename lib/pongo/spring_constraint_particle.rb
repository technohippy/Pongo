require 'pongo/circle_particle'
require 'pongo/rectangle_particle'
require 'pongo/common/math_util'
require 'pongo/common/vector'

module Pongo
  class SpringConstraintParticle < RectangleParticle
    attr_accessor :parent, :p1, :p2, :avg_velocity, :lamda, :scale_to_length, :rca, :rcb, :s, :rect_scale, :rect_height, :fixed_end_limit

    def initialize(p1, p2, p, rect_height, rect_scale, scale_to_length)
      super(0.0, 0.0, 0.0, 0.0, :fixed => false)

      @p1 = p1
      @p2 = p2

      self.lamda = Vector.new
      self.avg_velocity = Vector.new

      @parent = p
      @rect_scale = rect_scale
      @rect_height = rect_height
      @scale_to_length = scale_to_length

      @fixed_end_limit = 0.0
      @rca = Vector.new
      @rcb = Vector.new
    end

    def mass
      (@p1.mass * @p2.mass) / 2.0
    end

    def elasticity
      (@p1.elasticity * @p2.elasticity) / 2.0
    end

    def friction
      (@p1.friction * @p2.friction) / 2.0
    end

    def velocity
      p1v = @p1.velocity
      p2v = @p2.velocity
      @avg_velocity.set_to((p1v.x + p2v.x) / 2.0, (p1v.y + p2v.y) / 2.0)
    end

    def init
      #throw NotImplementedError
    end

    def draw
      #throw NotImplementedError
    end

    def init_display
      #throw NotImplementedError
    end

    def inv_mass
      if @p1.fixed? and @p2.fixed?
        0
      else
        1.0 / self.mass
      end
    end

    def fixed?
      @parent.fixed?
    end
    alias fixed fixed?

    # called only on collision
    def update_position
      @curr.set_to(@parent.center)
      self.width = @scale_to_length \
        ? @parent.curr_length * @rect_scale \
        : @parent.rest_length * @rect_scale
      self.height = @rect_height
      self.radian = @parent.radian
    end

    def resolve_collision(mtd, vel, n, d, o, p)
      test_particle_events(p)
      return if fixed? or not p.solid?

      t = contact_point_param(p)
      c1 = 1 -t
      c2 = t

      # if one is fixed then move the other particle the entire way out of 
      # collision. also, dispose of collisions at the sides of the scp. The higher
      # the fixedEndLimit value, the more of the scp not be effected by collision. 
      if @p1.fixed?
        return if c2 <= @fixed_end_limit
        lamda.set_to(mtd.x / c2, mtd.y / c2)
        @p2.curr.plus!(lamda)
        @p2.velocity = vel
      elsif @p2.fixed?
        return if c1 <= @fixed_end_limit
        lamda.set_to(mtd.x / c1, mtd.y / c1)
        @p1.curr.plus!(lamda)
        @p1.velocity = vel
      else
        # else both non fixed - move proportionally out of collision
        denom = c1 * c1 + c2 * c2
        return if denom == 0
        lamda.set_to(mtd.x / denom, mtd.y / denom)

        @p1.curr.plus!(lamda * c1)
        @p2.curr.plus!(lamda * c2)
        
        if t == 0.5
          # if collision is in the middle of SCP set the velocity of both end 
          # particles
          @p1.velocity = vel
          @p2.velocity = vel
        else
          # otherwise change the velocity of the particle closest to contact
          corr_particle = t < 0.5 ? @p1 : @p2
          corr_particle.velocity = vel
        end
      end
    end

    # given point c, returns a parameterized location on this SCP. Note
    # this is just treating the SCP as if it were a line segment (ab).
    def closest_param_point(c)
      ab = @p2.curr - @p1.curr
      t = (ab.dot(c - @p1.curr)) / (ab.dot(ab))
      MathUtil.clamp(t, 0.0, 1.0)
    end

    # returns a contact location on this SCP expressed as a parametric value in [0,1]
    def get_contact_point_param(p)
      if p.is_a?(CircleParticle)
        closest_param_point(p.curr)
      elsif p.is_a?(RectangleParticle)
        # go through the sides of the colliding rectangle as line segments
        shortest_index = 0
        params_list = []
        shortest_distance = Numeric::POSITIVE_INFINITY
        4.times do |i|
          set_corners(p, i)

          # check for closest points on SCP to side of rectangle
          d = closest_pt_segment_segment
          if d < shortest_distance
            shortest_distance = d
            shortest_index = i
            params_list[i] = @s
          end
          params_list[shortest_index]
        end
      end
    end
    alias contact_point_param get_contact_point_param

    def set_corners(r, i)
      rx = r.curr.x
      ry = r.curr.y

      axes = r.axes
      extents = r.extents

      ae0_x = axes[0].x * extents[0]
      ae0_y = axes[0].y * extents[0]
      ae1_x = axes[1].x * extents[1]
      ae1_y = axes[1].y * extents[1]

      emx = ae0_x - ae1_x
      emy = ae0_y - ae1_y
      epx = ae0_x + ae1_x
      epy = ae0_y + ae1_y

      case i
      when 0
        # 0 and 1
        @rca.x = rx - epx;
        @rca.y = ry - epy;
        @rcb.x = rx + emx;
        @rcb.y = ry + emy;
      when 1
        # 1 and 2
        @rca.x = rx + emx;
        @rca.y = ry + emy;
        @rcb.x = rx + epx;
        @rcb.y = ry + epy;
      when 2
        # 2 and 3
        @rca.x = rx + epx;
        @rca.y = ry + epy;
        @rcb.x = rx - emx;
        @rcb.y = ry - emy;
      when 3
        # 3 and 0
        @rca.x = rx - emx;
        @rca.y = ry - emy;
        @rcb.x = rx - epx;
        @rcb.y = ry - epy;
      end
    end

    # pp1-pq1 will be the SCP line segment on which we need parameterized s. 
    def closest_pt_segment_segment
      pp1 = @p1.curr
      pq1 = @p2.curr
      pp2 = @rca
      pq2 = @rcb

      d1 = pq1 - pp1
      d2 = pq2 - pp2
      r = pp1 - pp2

      a = d1.dot(d1)
      e = d2.dot(d2)
      f = d2.dot(r)

      c = d1.dot(r)
      b = d1.dot(d2)
      denom = a * e - b * b

      s = denom != 0.0 ? MathUtil.clamp((b * f - c * e) / denom, 0.0, 1.0) : 0.5
      t = (b * s + f) / e

      t, s = t < 0 \
        ? [0.0, MathUtil.clamp(-c / a, 0.0, 1.0)] \
        : [1.0, MathUtil.clamp((b - c) / a, 0.0, 1.0)]

      c1 = pp1 + (d1 * s)
      c2 = pp2 + (d2 * t)
      c1mc2 = c1 - c2
      c1mc2.dot(c1mc2)
    end
  end
end
