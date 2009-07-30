require 'pongo/group'
require 'pongo/circle_particle'
require 'pongo/spring_constraint'

class Car < Pongo::Group
  include Pongo

  attr_accessor :wheel_particle_a, :wheel_particle_b

  def initialize(col_c, col_e)
    super()

    @wheel_particle_a = WheelParticle.new(140, 10, 14, :mass => 2)
    add_particle(@wheel_particle_a)

    @wheel_particle_b = WheelParticle.new(200, 10, 14, :mass => 2)
    add_particle(@wheel_particle_b)

    wheel_connector = SpringConstraint.new(@wheel_particle_a, @wheel_particle_b, :collidable => true, :rect_height => 8)
    add_constraint(wheel_connector)
  end

  def speed=(s)
    @wheel_particle_a.angular_velocity = s
    @wheel_particle_b.angular_velocity = s
  end
end
