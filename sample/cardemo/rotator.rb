require 'pongo/group'
require 'pongo/circle_particle'
require 'pongo/spring_constraint'
require 'cardemo/rect_composite'

class Rotator < Pongo::Group
  include Pongo

  attr_accessor :ctr, :rect_composite

  def initialize(col_a, col_b)
    super(true)

    @ctr = Vector.new(555, 175)
    @rect_composite = RectComposite.new(@ctr, col_a, col_b)
    add_composite(@rect_composite)

    circ_a = CircleParticle.new(@ctr.x, @ctr.y, 5)
    add_particle(circ_a)

    rect_a = RectangleParticle.new(555, 160, 10, 10, :mass => 3)
    add_particle(rect_a)

    connector_a = SpringConstraint.new(@rect_composite.pa, rect_a, :stiffness => 1)
    add_constraint(connector_a)

    rect_b = RectangleParticle.new(555, 190, 10, 10, :mass => 3)
    add_particle(rect_b)

    connector_b = SpringConstraint.new(@rect_composite.pc, rect_b, :stiffness => 1)
    add_constraint(connector_b)
  end

  def rotate_by_radian(a)
    @rect_composite.rotate_by_radian(a, @ctr)
  end
end
