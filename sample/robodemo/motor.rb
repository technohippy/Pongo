class Motor < Pongo::Composite
  include Pongo
  ONE_THIRD = Math::PI * 2 / 3

  attr_accessor :wheel, :radius, :rim_a, :rim_b, :rim_c, :sg, :color

  def initialize(attach, radius, color)
    super()

    # @sg = sprite.graphics

    @wheel = WheelParticle.new(attach.px, attach.py - 0.01, radius)
    axle = SpringConstraint.new(@wheel, attach)

    @rim_a = CircleParticle.new(0, 0, 2, :fixed => true)
    @rim_b = CircleParticle.new(0, 0, 2, :fixed => true)
    @rim_c = CircleParticle.new(0, 0, 2, :fixed => true)

    @wheel.collidable = false
    @rim_a.collidable = false
    @rim_b.collidable = false
    @rim_c.collidable = false

    add_particle(@rim_a)
    add_particle(@rim_b)
    add_particle(@rim_c)
    add_particle(@wheel)
    add_constraint(axle)

    self.color = color
    self.radius = radius

    # run it once to make sure the rim particles are in the right place
    run
  end

  def power=(p)
    @wheel.speed = p
  end

  def power
    @wheel.speed
  end

  def run
    # align the rim particle based on the wheel rotation
    theta = @wheel.radian
    @rim_a.px = -@radius * Math.sin(theta) + @wheel.px
    @rim_a.py =  @radius * Math.cos(theta) + @wheel.py

    theta += ONE_THIRD
    @rim_b.px = -@radius * Math.sin(theta) + @wheel.px
    @rim_b.py =  @radius * Math.cos(theta) + @wheel.py

    theta += ONE_THIRD
    @rim_c.px = -@radius * Math.sin(theta) + @wheel.px
    @rim_c.py =  @radius * Math.cos(theta) + @wheel.py
  end

=begin
  # doing some custom painting here. contrast this with the custom painting of the
  # legs. in this case we draw the shape in the init method, and then just move/rotate
  # it in the paint method. one important thing here - the initial drawing happens in
  # object space (i.e., x = 0, y = 0) not world space. Another option would be to
  # just draw everything dynamically using the wheel and rim point locations.
  def init
  end

  def paint
  end
=end
end
