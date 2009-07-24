module Pongo
  class Composite < AbstractCollection
    attr_accessor :delta

    def initialize
      super
      @delta = Vector.new
    end

    # Rotates the Composite to an angle specified in radians, around a given center
    def rotate_by_radian(angle_radians, center)
      @particles.each do |p|
        radius = p.center.distance(center)
        angle = relative_angle(center, p.center) + angle_radians
        p.px = (Math.cos(angle) * radius) + center.x
        p.py = (Math.sin(angle) * radius) + center.y
      end
    end

    def rotate_by_angle(angle_degrees, center)
      rotate_by_radian(angle_degrees * MathUtil::PI_OVER_ONE_EIGHTY, center)
    end

    def fixed
      @particles.each do |p|
        return false unless p.fixed?
      end
      true
    end
    alias fixed? fixed

    def fixed=(b)
      @particles.each {|p| p.fixed = b}
    end

    def get_relative_angle(center, p)
      @delta.set_to(p.x - center.x, p.y - center.y)
      Math.atan2(@delta.y, @delta.x)
    end
    alias relative_angle get_relative_angle
  end
end
