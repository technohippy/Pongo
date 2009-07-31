require 'pongo/composite'
require 'pongo/circle_particle'
require 'pongo/spring_constraint'

class RectComposite < Pongo::Composite
  include Pongo

  attr_accessor :cp_a, :cp_c

  def initialize(ctr, col_a, col_b)
    super()

    rw = 75
    rh = 18
    rad = 4

    @cp_a = CircleParticle.new(ctr.x - rw/2, ctr.y - rh/2, rad, :fixed => true)
    cp_b = CircleParticle.new(ctr.x + rw/2, ctr.y - rh/2, rad, :fixed => true)
    @cp_c = CircleParticle.new(ctr.x + rw/2, ctr.y + rh/2, rad, :fixed => true)
    cp_d = CircleParticle.new(ctr.x - rw/2, ctr.y + rh/2, rad, :fixed => true)

    @cp_a.always_redraw = true
    cp_b.always_redraw = true
    @cp_c.always_redraw = true
    cp_d.always_redraw = true

    spr_a = SpringConstraint.new(@cp_a, cp_b, :collidable => true, :rect_height => rad * 2)
    spr_b = SpringConstraint.new(cp_b, @cp_c, :collidable => true, :rect_height => rad * 2)
    spr_c = SpringConstraint.new(@cp_c, cp_d, :collidable => true, :rect_height => rad * 2)
    spr_d = SpringConstraint.new(cp_d, @cp_a, :collidable => true, :rect_height => rad * 2)

    spr_a.always_redraw = true
    spr_b.always_redraw = true
    spr_c.always_redraw = true
    spr_d.always_redraw = true

    add_particle(@cp_a)
    add_particle(cp_b)
    add_particle(@cp_c)
    add_particle(cp_d)

    add_constraint(spr_a)
    add_constraint(spr_b)
    add_constraint(spr_c)
    add_constraint(spr_d)
  end

  def pa
    @cp_a
  end

  def pc
    @cp_c
  end
end
