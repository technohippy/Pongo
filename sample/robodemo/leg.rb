class Leg < Pongo::Composite
  include Pongo
  attr_accessor :sg, :pa, :pb, :pc, :pd, :pe, :pf, :ph
  attr_accessor :line_color, :line_alpha, :line_weight
  attr_accessor :fill_color, :fill_alpha, :visible

  def initialize(px, py, orientation, scale, line_weight, line_color, line_alpha, fill_color, fill_alpha)
    super()

    self.line_color = line_color
    self.line_alpha = line_alpha
    self.line_weight = line_weight

    self.fill_color = fill_color
    self.fill_alpha = fill_alpha

    # @sg = sprite.graphics

    # top triangle -- pa is the attach point to the body
    os = orientation * scale
    @pa = CircleParticle.new(px + 31 * os, py - 8  * scale, 1)
    @pb = CircleParticle.new(px + 25 * os, py - 37 * scale, 1)
    @pc = CircleParticle.new(px + 60 * os, py - 15 * scale, 1)

    # bottom triangle particles -- pf is the foot
    @pd = CircleParticle.new(px + 72 * os, py + 12 * scale, 1)
    @pe = CircleParticle.new(px + 43 * os, py + 19 * scale, 1)
    @pf = CircleParticle.new(px + 54 * os, py + 61 * scale, 2)

    # strut attach point particle
    @ph = CircleParticle.new(px, py, 3)

    # top triangle constraints
    cab = SpringConstraint.new(@pa, @pb, 1)
    cbc = SpringConstraint.new(@pb, @pc, 1)
    cca = SpringConstraint.new(@pc, @pa, 1)

    # middle leg constraints
    ccd = SpringConstraint.new(@pc, @pd, 1)
    cae = SpringConstraint.new(@pa, @pe, 1)

    # bottom leg constraints
    cde = SpringConstraint.new(@pd, @pe, 1)
    cdf = SpringConstraint.new(@pd, @pf, 1)
    cef = SpringConstraint.new(@pe, @pf, 1)

    # cam constraints
    cbh = SpringConstraint.new(@pb, @ph, 1)
    ceh = SpringConstraint.new(@pe, @ph, 1)

    add_particle(@pa)
    add_particle(@pb)
    add_particle(@pc)
    add_particle(@pd)
    add_particle(@pe)
    add_particle(@pf)
    add_particle(@ph)

    add_constraint(cab)
    add_constraint(cbc)
    add_constraint(cca)
    add_constraint(ccd)
    add_constraint(cae)
    add_constraint(cde)
    add_constraint(cdf)
    add_constraint(cef)
    add_constraint(cbh)
    add_constraint(ceh)

    # for added efficiency, only test the feet (pf) for collision. these
    # selective tweaks should always be considered for best performance.
    @pa.collidable = false
    @pb.collidable = false
    @pc.collidable = false
    @pd.collidable = false
    @pe.collidable = false
    @ph.collidable = false
    
    @visible = true
  end

  def cam
    @ph
  end

  def fix
    @pa
  end

=begin
  # in most cases when you want to do custom painting youll need to override init because
  # it sets up the sprites with vector drawings that get moved around in the default paint
  # method. in this case were dynamically drawing the legs so we dont need to do anything
  # with the init override, eg draw the leg first and then move it around in the paint method.
  # by doing nothing here we prevent the init from being called on all the particles and 
  # constraints of the leg, which is what we want.
  def init
  end

  def paint
  end
=end
end
