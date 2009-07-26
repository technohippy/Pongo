require 'pongo/abstract_collection'
require 'pongo/common/numeric_ext'

module Pongo
  # The Composite class can contain Particles, and Constraints. Composites can be added
  # to a parent Group, along with Particles and Constraints.  Members of a Composite
  # are not checked for collision with one another, internally.
  class Composite < AbstractCollection
    attr_accessor :delta

    def initialize
      super
      @delta = Vector.new
    end

    # Rotates the Composite to an angle specified in radians, around a given center
    def rotate_by_radian(angle_radians, center)
      particles.each do |p|
        radius = p.center.distance(center)
        angle = relative_angle(center, p.center) + angle_radians
        p.px = (Math.cos(angle) * radius) + center.x
        p.py = (Math.sin(angle) * radius) + center.y
      end
    end

    # Rotates the Composite to an angle specified in degrees, around a given center
    def rotate_by_angle(angle_degrees, center)
      rotate_by_radian(angle_degrees * Numeric::PI_OVER_ONE_EIGHTY, center)
    end

    # The fixed state of the Composite. Setting this value to true or false will
    # set all of this Composite's component particles to that value. Getting this 
    # value will return false if any of the component particles are not fixed.
    def fixed?
      particles.each do |p|
        return false unless p.fixed?
      end
      true
    end
    alias fixed fixed?

    def fixed=(b)
      particles.each {|p| p.fixed = b}
    end

    def relative_angle(center, p)
      @delta.set_to(p.x - center.x, p.y - center.y)
      Math.atan2(@delta.y, @delta.x)
    end
    alias get_relative_angle relative_angle
  end
end
