$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__) + '/../lib'
require 'pongo'
require 'pongo/renderer/shoes_renderer'
require 'pongo/logger/shoes_logger'

require 'robodemo/robot'

include Pongo
Shoes.app :width => 1200, :height => 350 do
  APEngine.renderer = Renderer::ShoesRenderer.new(self)
  APEngine.logger = Logger::ShoesLogger.new(self)
  APEngine.setup
  APEngine.damping = 0.99
  APEngine.constraint_collision_cycles = 10
  APEngine.add_force VectorForce.new(false, 0, 2)

  default_group = Group.new
  default_group.collide_internal = true

  @robot = Robot.new(1000, 260, 1.6, 0.02)

  terrain_a = Group.new
  terrain_b = Group.new(true)
  terrain_c = Group.new

  floor = RectangleParticle.new(600, 390, 1700, 100, 
    :fixed => true, :elasticity => 0, :friction => 1)
  terrain_a.add_particle(floor)

  # pyramid of boxes
  box0 = RectangleParticle.new(400, 337, 600, 7, 
    :fixed => true, :mass => 10, :elasticity => 0, :friction => 1)
  terrain_a.add_particle(box0)

  box1 = RectangleParticle.new(400, 330, 500, 7, 
    :fixed => true, :mass => 10, :elasticity => 0, :friction => 1)
  terrain_a.add_particle(box1)

  box2 = RectangleParticle.new(400, 323, 400, 7, 
    :fixed => true, :mass => 10, :elasticity => 0, :friction => 1)
  terrain_a.add_particle(box2)

  box3 = RectangleParticle.new(400, 316, 300, 7, 
    :fixed => true, :mass => 10, :elasticity => 0, :friction => 1)
  terrain_a.add_particle(box3)

  box4 = RectangleParticle.new(400, 309, 200, 7, 
    :fixed => true, :mass => 10, :elasticity => 0, :friction => 1)
  terrain_a.add_particle(box4)

  box5 = RectangleParticle.new(400, 302, 100, 7, 
    :fixed => true, :mass => 10, :elasticity => 0, :friction => 1)
  terrain_a.add_particle(box5)

  # left side floor
  floor2 = RectangleParticle.new(-100, 390, 1100, 100,
    :rotation => 0.3, :fixed => true, :elasticity => 0, :friction => 1)
  terrain_a.add_particle(floor2)

  # snip...

  # right side floor
  floor6 = RectangleParticle.new(1430, 320, 50, 60,
    :fixed => true)

  APEngine.add_group(@robot)
  APEngine.add_group(terrain_a)
  APEngine.add_group(terrain_b)
  APEngine.add_group(terrain_c)

  @robot.add_collidable(terrain_a)
  @robot.add_collidable(terrain_b)
  @robot.add_collidable(terrain_c)

  @robot.toggle_power

  button 'power' do
    @robot.toggle_power
  end
  button 'direction' do
    @robot.toggle_direction
  end

  animate(60) do |anim|
    @robot.run
    APEngine.step
    APEngine.draw
  end
end
