require 'pongo/group'
require 'pongo/circle_particle'
require 'pongo/spring_constraint'

class SwingDoor < Pongo::Group
  include Pongo

  def initialize(col_e)
    super(true)

    swing_door_p1 = CircleParticle.new(543, 55, 7, :mass => 0.001)
swing_door_p1.user_data[:name] = 'swing_door_p1'
    add_particle(swing_door_p1)

    swing_door_p2 = CircleParticle.new(620, 55, 7, :fixed => true)
swing_door_p2.user_data[:name] = 'swing_door_p2'
    add_particle(swing_door_p2)

    swing_door = SpringConstraint.new(swing_door_p1, swing_door_p2, :stiffness => 1, :collidable => true, :rect_height => 13)
    add_constraint(swing_door)

    swing_door_anchor = CircleParticle.new(543, 5, 2, :fixed => true, :collidable => false)
swing_door_anchor.user_data[:name] = 'swing_door_anchor'
    swing_door_anchor.visible = false
    add_particle(swing_door_anchor)

    swing_door_spring = SpringConstraint.new(swing_door_p1, swing_door_anchor, :stiffness => 0.02)
    swing_door_spring.visible = false
    add_constraint(swing_door_spring)

    stopper_a = CircleParticle.new(550, -60, 70, :fixed => true)
stopper_a.user_data[:name] = 'stopper_a'
    stopper_a.visible = false
    add_particle(stopper_a)

    stopper_b = RectangleParticle.new(650, 130, 42, 70, :fixed => true)
    stopper_b.visible = false
    add_particle(stopper_b)
  end
end
