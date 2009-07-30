require 'pongo/group'
require 'robodemo/body'
require 'robodemo/leg'
require 'robodemo/motor'

class Robot < Pongo::Group
  include Pongo
  attr_accessor :body, :moter, :direction, :power_level, :powered, :legs_visible
  attr_accessor :leg_la, :leg_ra, :leg_lb, :leg_rb, :leg_lc, :leg_rc

  def initialize(px, py, scale, power)
    super()

    # legs
    @leg_la = Leg.new(px, py, -1, scale, 2, 0x444444, 1, 0x222222, 1)
    @leg_ra = Leg.new(px, py,  1, scale, 2, 0x444444, 1, 0x222222, 1)
    @leg_lb = Leg.new(px, py, -1, scale, 2, 0x666666, 1, 0x444444, 1)
    @leg_rb = Leg.new(px, py,  1, scale, 2, 0x666666, 1, 0x444444, 1)
    @leg_lc = Leg.new(px, py, -1, scale, 2, 0x888888, 1, 0x666666, 1)
    @leg_rc = Leg.new(px, py,  1, scale, 2, 0x888888, 1, 0x666666, 1)

    # body
    @body = Body.new(@leg_la.fix, @leg_ra.fix, 30 * scale, 2, 0x336699, 1)

    # motor
    @motor = Motor.new(@body.center, 8 * scale, 0x336699)

    # connect the body to the legs
    conn_la = SpringConstraint.new(@body.left,  @leg_la.fix, :stiffness => 1)
    conn_ra = SpringConstraint.new(@body.right, @leg_ra.fix, :stiffness => 1)
    conn_lb = SpringConstraint.new(@body.left,  @leg_lb.fix, :stiffness => 1)
    conn_rb = SpringConstraint.new(@body.right, @leg_rb.fix, :stiffness => 1)
    conn_lc = SpringConstraint.new(@body.left,  @leg_lc.fix, :stiffness => 1)
    conn_rc = SpringConstraint.new(@body.right, @leg_rc.fix, :stiffness => 1)

    # connect to legs to the motor
    @leg_la.cam.position = @motor.rim_a.position
    @leg_ra.cam.position = @motor.rim_a.position
    conn_laa = SpringConstraint.new(@leg_la.cam, @motor.rim_a, :stiffness => 1)
    conn_raa = SpringConstraint.new(@leg_ra.cam, @motor.rim_a, :stiffness => 1)

    @leg_lb.cam.position = @motor.rim_b.position
    @leg_rb.cam.position = @motor.rim_b.position
    conn_lbb = SpringConstraint.new(@leg_lb.cam, @motor.rim_b, :stiffness => 1)
    conn_rbb = SpringConstraint.new(@leg_rb.cam, @motor.rim_b, :stiffness => 1)

    @leg_lc.cam.position = @motor.rim_c.position
    @leg_rc.cam.position = @motor.rim_c.position
    conn_lcc = SpringConstraint.new(@leg_lc.cam, @motor.rim_c, :stiffness => 1)
    conn_rcc = SpringConstraint.new(@leg_rc.cam, @motor.rim_c, :stiffness => 1)

    # add to the engine
    add_composite(@leg_la)
    add_composite(@leg_ra)
    add_composite(@leg_lb)
    add_composite(@leg_rb)
    add_composite(@leg_lc)
    add_composite(@leg_rc)

    add_composite(@body)
    add_composite(@motor)

    add_constraint(conn_la)
    add_constraint(conn_ra)
    add_constraint(conn_lb)
    add_constraint(conn_rb)
    add_constraint(conn_lc)
    add_constraint(conn_rc)

    add_constraint(conn_laa)
    add_constraint(conn_raa)
    add_constraint(conn_lbb)
    add_constraint(conn_rbb)
    add_constraint(conn_lcc)
    add_constraint(conn_rcc)

    @direction = -1
    @power_level = power
    @powered = true
    @legs_visible = true
  end

  def px
    @body.center.px
  end

  def py
    @body.center.py
  end

  def run
    @motor.run
  end

  def toggle_power
    @powered = !@powered

    if @powered
      @motor.power = @power_level * @direction
      @stiffness = 1
      APEngine.damping = 0.99
    else
      @motor.power= 0
      @stiffness = 0.2
      APEngine.damping = 0.35
    end
  end

  def toggle_direction
    @direction *= -1
    @motor.power = @power_level * @direction
  end

  def toggle_legs
    @leg_visible = !@leg_visible
    unless @leg_visible
      @leg_la.visible = false
      @leg_ra.visible = false
      @leg_lb.visible = false
      @leg_rb.visible = false
    else
      @leg_la.visible = true
      @leg_ra.visible = true
      @leg_lb.visible = true
      @leg_rb.visible = true
    end
  end

  def stiffness=(s)
    # top level constraints in the group
    @constraints.each do |sp|
      sp.stiffness = s
    end

    # constraints within this groups composites
    @composites.each do |composite|
      composite.constraints.each do |sp|
        sp.stiffness = s
      end
    end
  end
end
