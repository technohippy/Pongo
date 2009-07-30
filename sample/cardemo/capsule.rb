require 'pongo/group'
require 'pongo/circle_particle'
require 'pongo/spring_constraint'

class Capsule < Pongo::Group
  include Pongo

  def initialize(col_c)
    super()

    capsule_p1 = CircleParticle.new(300, 10, 14, :mass => 1.3, :elasticity => 0.4)
capsule_p1.user_data[:name] = 'capsule_p1'
    add_particle(capsule_p1)

    capsule_p2 = CircleParticle.new(325, 35, 14, :mass => 1.3, :elasticity => 0.4)
capsule_p2.user_data[:name] = 'capsule_p2'
    add_particle(capsule_p2)

    capsule = SpringConstraint.new(capsule_p1, capsule_p2, :stiffness => 1, :collidable => true, :rect_height => 24)
    add_constraint(capsule)
  end
end
