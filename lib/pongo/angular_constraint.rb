require 'pongo/spring_constraint'

module Pongo
  class AngularConstraint < SpringConstraint
    attr_accessor :p3, :min_ang, :max_ang, :min_break_ang, :max_break_ang

    def initialize(p1, p2, p3, min_ang, max_ang, min_break_ang=-10, max_break_ang=10, stiffness=0.5, dependent=false, collidable=false, rect_height=1, rect_scale=1, scale_to_length=false)
      super(p2, p2, stiffness, false, dependent, collidable, rect_height, rect_scale, scale_to_length)
      @p3 = p3
      if min_ang == 10
        @min_ang = ac_radian
        @max_ang = ac_radian
      else
        @min_ang = min_ang
        @max_ang = max_ang
      end
      @min_break_ang = min_break_ang
      @max_break_ang = max_break_ang
    end

    def ac_radian
      ang12 = Math.atan2(@p2.curr.y - @p1.curr.y, @p2.curr.x - @p1.curr.x)
      ang23 = Math.atan2(@p3.curr.y - @p2.curr.y, @p3.curr.x - @p2.curr.x)
      ang12 - ang23
    end

    def is_connected_to?(p)
      [@p1, @p2, @p3].include?(p)
    end

    def fixed
      @p1.fixed? and @p2.fixed? and @p3.fixed?
    end
    alias fixed? fixed

    def resolve
      return if broken
      
      ang12 = Math.atan2(@p2.curr.y - @p1.curr.y, @p2.curr.x - @p1.curr.x)
      ang23 = Math.atan2(@p3.curr.y - @p2.curr.y, @p3.curr.x - @p2.curr.x)

      ang_diff = normalize_angle(ang12 - ang23)

      p2_inv_mass = dependent ? 0 : @p2.inv_mass

      sum_inv_mass = @p1.inv_mass + @p2.inv_mass
      mult1 = @p1.inv_mass / sum_inv_mass
      mult2 = p2_inv_mass / sum_inv_mass
      ang_change = 0

      low_mid = (@max_ang - @min_ang) / 2
      high_mid = (@max_ang + @min_ang) / 2
      break_ang = (@max_break_ang - @min_break_ang) / 2

      new_diff = normalize_angle(high_mid - ang_diff)

      if new_diff > low_mid
        if new_diff > break_ang
          diff = new_diff - break_ang
          broken = true
          if has_event_listener(BreakEvent::ANGULAR)
            dispatch_event(BreakEvent.new(BreakEvent::ANGULAR, diff))
          end
          return
        end
        ang_change = new_diff - low_mid
      elsif new_diff < -low_mid
        if new_diff < -break_ang
          diff = new_dif + break_ang
          broken = true
          if has_event_listener(BreakEvent::ANGULAR)
            dispatch_event(BreakEvent.new(BreakEvent::ANGULAR, diff))
          end
          return
        end
        ang_change = new_diff + low_mid
      end

      final_ang = ang_change * @stiffness + ang12
      displace_x = @p1.curr.x + (@p2.curr.x - @p1.curr.x) * mult1
      displace_y = @p1.curr.y + (@p2.curr.y - @p1.curr.y) * mult1

      @p1.curr.x = displace_x + Math.cos(final_ang + Math::PI) * rest_length * mult1
      @p1.curr.x = displace_y + Math.sin(final_ang + Math::PI) * rest_length * mult1
      @p2.curr.x = displace_x + Math.cos(final_ang) * rest_length * mult2
      @p2.curr.y = displace_y + Math.sin(final_ang) * rest_length * mult2
    end

    protected

    def normilize_angle(angle)
      pi2 = Math::PI * 2
      angle -= pi2 while angle > Math::PI
      angle += pi2 while angle < -Math::PI
      angle
    end
  end
end
