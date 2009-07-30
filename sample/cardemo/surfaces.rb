require 'pongo/group'
require 'pongo/rectangle_particle'
require 'pongo/circle_particle'

class Surfaces < Pongo::Group
  include Pongo

  def initialize(col_a, col_b, col_c, col_d, col_e)
    super()

    floor = RectangleParticle.new(340, 327, 550, 50, :fixed => true)
    add_particle(floor)

    ceil = RectangleParticle.new(325, -33, 649, 80, :fixed => true)
    add_particle(ceil)

    ramp_right = RectangleParticle.new(375, 220, 390, 20, :rotation => 0.405, :fixed => true)
    add_particle(ramp_right)

    ramp_left = RectangleParticle.new(90, 200, 102, 20, :rotation => -0.7, :fixed => true)
    add_particle(ramp_left)

    ramp_left2 = RectangleParticle.new(96, 129, 102, 20, :rotation => -0.7, :fixed => true)
    add_particle(ramp_left2)

    ramp_circle = CircleParticle.new(175, 190, 60, :fixed => true)
ramp_circle.user_data[:name] = 'ramp_circle'
    add_particle(ramp_circle)

    floor_bump = CircleParticle.new(600, 660, 400, :fixed => true)
floor_bump.user_data[:name] = 'floor_bump'
    add_particle(floor_bump)

    bounce_pad = RectangleParticle.new(35, 370, 40, 60, :fixed => true, :elasticity => 4)
    add_particle(bounce_pad)

    left_wall = RectangleParticle.new(1, 99, 30, 500, :fixed => true)
    add_particle(left_wall)

    left_wall_channel_inner = RectangleParticle.new(54, 300, 20, 150, :fixed => true)
    add_particle(left_wall_channel_inner)

    left_wall_channel = RectangleParticle.new(54, 122, 20, 94, :fixed => true)
    add_particle(left_wall_channel)

    left_wall_channel_ang = RectangleParticle.new(75, 65, 60, 25, :rotation => -0.7, :fixed => true)
    add_particle(left_wall_channel_ang)

    top_left_ang = RectangleParticle.new(23, 11, 65, 40, :rotation => -0.7, :fixed => true)
    add_particle(top_left_ang)

    right_wall = RectangleParticle.new(654, 230, 50, 500, :fixed => true)
    add_particle(right_wall)

    bridge_start = RectangleParticle.new(127, 49, 75, 25, :fixed => true)
    add_particle(bridge_start)

    bridge_end = RectangleParticle.new(483, 55, 100, 15, :fixed => true)
    add_particle(bridge_end)
  end
end
