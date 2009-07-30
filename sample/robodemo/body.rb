class Body < Pongo::Composite
  include Pongo
  attr_accessor :top, :rgt, :lft, :bot, :ctr

  def initialize(left, right, height, line_weight, line_color, line_alphat)
    super()

    cpx = (right.px + left.px) / 2
    cpy = right.py

    @rgt = CircleParticle.new(right.px, right.py, 1)
    @lft = CircleParticle.new(left.px, left.py, 1)

    @ctr = CircleParticle.new(cpx, cpy, 1)
    @ctr.visible = false
    @top = CircleParticle.new(cpx, cpy - height / 2, 1)
    @top.visible = false
    @bot = CircleParticle.new(cpx, cpy + height / 2, 1)
    @bot.visible = false

    # outer constraints
    tr = SpringConstraint.new(@top, @rgt, :stiffness => 1)
    tr.visible = false
    rb = SpringConstraint.new(@rgt, @bot, :stiffness => 1)
    rb.visible = false
    bl = SpringConstraint.new(@bot, @lft, :stiffness => 1)
    bl.visible = false
    lt = SpringConstraint.new(@lft, @top, :stiffness => 1)
    lt.visible = false

    # inner constrainst
    ct = SpringConstraint.new(@lft, center, :stiffness => 1)
    ct.visible = false
    cr = SpringConstraint.new(@rgt, center, :stiffness => 1)
    cb = SpringConstraint.new(@bot, center, :stiffness => 1)
    cb.visible = false
    cl = SpringConstraint.new(@lft, center, :stiffness => 1)

    @ctr.collidable = false
    @top.collidable = false
    @rgt.collidable = false
    @bot.collidable = false
    @lft.collidable = false

    add_particle(@ctr)
    add_particle(@top)
    add_particle(@rgt)
    add_particle(@bot)
    add_particle(@lft)

    add_constraint(tr)
    add_constraint(rb)
    add_constraint(bl)
    add_constraint(lt)

    add_constraint(ct)
    add_constraint(cr)
    add_constraint(cb)
    add_constraint(cl)
  end

  def left
    @lft
  end

  def center
    @ctr
  end

  def right
    @rgt
  end
end
