$: << File.dirname(__FILE__) + '/..'
$: << File.dirname(__FILE__) + '/../../lib'
require 'tk'
require 'pongo'
require 'pongo/renderer/tk_renderer'
require 'pongo/logger/standard_logger'

require 'robodemo/robot'

include Pongo

root = TkRoot.new {title 'Robodemo'}
canvas = TkCanvas.new(root, :width => 1200, :height => 350)
canvas.pack
APEngine.renderer = Renderer::TkRenderer.new(canvas)
APEngine.logger = Logger::StandardLogger.new
APEngine.setup
APEngine.damping = 0.99
APEngine.constraint_collision_cycles = 10
APEngine.add_force VectorForce.new(false, 0, 2)

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

TkButton.new(:text => 'power', :command => lambda{@robot.toggle_power}).pack
TkButton.new(:text => 'direction', :command => lambda{@robot.toggle_direction}).pack

TkTimer.start(10) do |timer|
  begin
    @robot.run
    APEngine.step
    APEngine.draw
  rescue
    APEngine.log("#{$!.message}\n#{$!.backtrace.join("\n")}")
  end
end
Tk.mainloop
