require 'pongo/common/numeric_ext'
module Pongo
  class CollisionDetector
    class <<self
      attr_accessor :cpa, :cpb, :coll_normal, :coll_depth

      # Tests the collision between two objects. This initial test determines
      # the multisampling state of the two particles.
      def test(obj_a, obj_b)
        return if obj_a == obj_b # TODO: added by ando
        return if obj_a.fixed? and obj_b.fixed?

        if obj_a.multisample == 0 and obj_b.multisample == 0
          norm_vs_norm(obj_a, obj_b)
        elsif obj_a.multisample > 0 and obj_b.multisample == 0
          samp_vs_norm(obj_a, obj_b)
        elsif obj_b.multisample > 0 and obj_a.multisample == 0
          samp_vs_norm(obj_b, obj_a)
        elsif obj_a.multisample == obj_b.multisample
          samp_vs_samp(obj_a, obj_b)
        else
          norm_vs_norm(obj_a, obj_b)
        end
      end

      # default test for two non-multisampled particles
      def norm_vs_norm(obj_a, obj_b)
        obj_a.samp.copy(obj_a.curr)
        obj_b.samp.copy(obj_b.curr)
        if test_types(obj_a, obj_b)
          CollisionResolver.resolve(@cpa, @cpb, @coll_normal, @coll_depth)
          true
        else
          false
        end
      end

      # Tests two particles where one is multisampled and the other is not. Let objectA
      # be the multisampled particle.
      def samp_vs_norm(obj_a, obj_b)
        return if norm_vs_norm(obj_a, obj_b)

        s = 1 / (obj_a.multisample + 1)
        t = s
        obj_a.multisample.times do
          obj_a.samp.set_to(
            obj_a.prev.x + t * (obj_a.curr.x - obj_a.prev.x),
            obj_a.prev.y + t * (obj_a.curr.y - obj_a.prev.y)
          )
          if test_types(obj_a, obj_b)
            CollisionResolver.resolve(@cpa, @cpb, @coll_normal, @coll_depth)
            return
          end
          t += s
        end
      end

      # Tests two particles where both are of equal multisample rate
      def samp_vs_samp(obj_a, obj_b)
        return if norm_vs_norm(obj_a, obj_b)

        s = 1 / (obj_a.multisample + 1)
        t = s

        obj_a.multisample.times do
          obj_a.samp.set_to(
            obj_a.prev.x + t * (obj_a.curr.x - obj_a.prev.x),
            obj_a.prev.y + t * (obj_a.curr.y - obj_a.prev.y)
          )
          obj_b.samp.set_to(
            obj_b.prev.x + t * (obj_b.curr.x - obj_b.prev.x),
            obj_b.prev.y + t * (obj_b.curr.y - obj_b.prev.y)
          )
          if test_types(obj_a, obj_b)
            CollisionResolver.resolve(@cpa, @cpb, @coll_normal, @coll_depth)
            return
          end
          t += s
        end
      end

      # Tests collision based on primitive type.
      def test_types(obj_a, obj_b)
        if obj_a.is_a?(RectangleParticle) and obj_b.is_a?(RectangleParticle)
          test_obb_vs_obb(obj_a, obj_b)
        elsif obj_a.is_a?(CircleParticle) and obj_b.is_a?(CircleParticle)
          test_circle_vs_circle(obj_a, obj_b)
        elsif obj_a.is_a?(RectangleParticle) and obj_b.is_a?(CircleParticle)
          test_obb_vs_circle(obj_a, obj_b)
        elsif obj_a.is_a?(CircleParticle) and obj_b.is_a?(RectangleParticle)
          test_obb_vs_circle(obj_b, obj_a)
        else
          false
        end
      end

      # Tests the collision between two RectangleParticles (aka OBBs). If there is a 
      # collision it determines its axis and depth, and then passes it off to the 
      # CollisionResolver for handling.
      def test_obb_vs_obb(rect_a, rect_b)
        @coll_depth = Numeric::POSITIVE_INFINITY
        2.times do |i|
          axis_a = rect_a.axes[i]
          depth_a = test_intervals(rect_a.projection(axis_a), rect_b.projection(axis_a))
          return false if depth_a == 0

          axis_b = rect_b.axes[i]
          depth_b = test_intervals(rect_a.projection(axis_b), rect_b.projection(axis_b))
          return false if depth_b == 0

          abs_a = depth_a.abs
          abs_b = depth_b.abs

          if abs_a < @coll_depth.abs or abs_b < @coll_depth.abs
            altb = abs_a < abs_b
            @coll_normal = altb ? axis_a : axis_b
            @coll_depth = altb ? depth_a : depth_b
          end
        end

        @cpa = rect_a
        @cpb = rect_b
        true
      end

      # Tests the collision between a RectangleParticle (aka an OBB) and a 
      # CircleParticle. If there is a collision it determines its axis and depth, and 
      # then passes it off to the CollisionResolver.
      def test_obb_vs_circle(rect_a, cir_a)
        @coll_depth = Numeric::POSITIVE_INFINITY
        depths = []

        # first go through the axes of the rectangle
        2.times do |i|
          box_axis = rect_a.axes[i]
          depth = test_intervals(rect_a.projection(box_axis), cir_a.projection(box_axis))
          return false if depth == 0

          if depth.abs < @coll_depth.abs
            @coll_normal = box_axis
            @coll_depth = depth
          end
          depths[i] = depth
        end

        # determine if the circle's center is in a vertex region
        r = cir_a.radius
        if depths[0].abs < r and depths[1].abs < r
          vertex = closest_vertex_on_obb(cir_a.samp, rect_a)

          # get the distance from the closest vertex on rect to circle center
          @coll_normal = vertex - cir_a.samp
          mag = @coll_normal.magnitude
          @coll_depth = r - mag

          if @coll_depth > 0
            # there is a collision in one of the vertex regions
            @coll_normal.div!(mag)
          else
            # rect_a is in vertex region, but is not colliding
            return false
          end
        end
        @cpa = rect_a
        @cpb = cir_a
        true
      end

      # Tests the collision between two CircleParticles. If there is a collision it 
      # determines its axis and depth, and then passes it off to the CollisionResolver
      # for handling.
      def test_circle_vs_circle(cir_a, cir_b)
        depth_x = test_intervals(cir_a.interval_x, cir_b.interval_x)
        return false if depth_x == 0

        depth_y = test_intervals(cir_a.interval_y, cir_b.interval_y)
        return false if depth_y == 0

        @coll_normal = cir_a.samp - cir_b.samp
        mag = @coll_normal.magnitude
        @coll_depth = cir_a.radius + cir_b.radius - mag

        if @coll_depth > 0
          @coll_normal.div!(mag)
          @cpa = cir_a
          @cpb = cir_b
          true
        else
          false
        end
      end

      # Returns 0 if intervals do not overlap. Returns smallest depth if they do.
      def test_intervals(interval_a, interval_b)
        return 0 if interval_a.max < interval_b.min
        return 0 if interval_b.max < interval_a.min

        len_a = interval_b.max - interval_a.min
        len_b = interval_b.min - interval_a.max

        len_a.abs < len_b.abs ? len_a : len_b
      end

      # Returns the location of the closest vertex on rect to point
      def closest_vertex_on_obb(point, rect)
        d = point - rect.samp
        q = rect.samp.dup

        2.times do |i|
          dist = d.dot(rect.axes[i])
          if    dist >= 0; dist = rect.extents[i] 
          elsif dist <  0; dist = -rect.extents[i]
          end

          q.plus!(rect.axes[i] * dist)
        end
        q
      end
    end
  end
end
