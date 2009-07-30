# http://www.garrahan.org/ape/?p=4
$: << File.dirname(__FILE__) + '/../../lib'
require 'tk'
require 'pongo'
require 'pongo/renderer/tk_renderer'
require 'pongo/logger/standard_logger'

include Pongo
root = TkRoot.new {title 'Basic'}
canvas = TkCanvas.new(root, :width => 700, :height => 600)
canvas.pack
APEngine.setup
APEngine.renderer = Renderer::TkRenderer.new(canvas)
APEngine.logger = Logger::StandardLogger.new
APEngine.gravity = VectorForce.new(false, 0, 2)
APEngine.damping = 0.97

default_group = Group.new(true)

my_circle = CircleParticle.new(155, 140, 15)

my_wheel = WheelParticle.new(245, 140, 30)

my_box = RectangleParticle.new(80, 150, 10, 80, :rotation => 0.2)

point1 = CircleParticle.new(340, 120, 5, :fixed => false, :elasticity => 4)
point2 = CircleParticle.new(380, 120, 5, :fixed => false, :elasticity => 4)
point3 = CircleParticle.new(380, 160, 5, :fixed => false, :elasticity => 4)
my_spring1 = SpringConstraint.new(point1, point2, :stiffness => 0.8)
my_spring2 = SpringConstraint.new(point2, point3, :stiffness => 0.8)
my_spring3 = SpringConstraint.new(point3, point1, :stiffness => 0.8)

my_floor1 = RectangleParticle.new(550, 450, 300, 20, 
  :rotation => 2.5, :fixed => true, :elasticity => 1)
my_floor2 = RectangleParticle.new(250, 300, 450, 20, 
  :rotation => 0.2, :fixed => true, :elasticity => 1)

default_group << my_circle
default_group << my_wheel
default_group << my_box
default_group << my_floor1
default_group << my_floor2

default_group << point1
default_group << point2
default_group << point3
default_group << my_spring1
default_group << my_spring2
default_group << my_spring3

APEngine.add_group(default_group)

TkTimer.start(10) do |timer|
  begin
    APEngine.step
    APEngine.draw
  rescue
    APEngine.log("#{$!.message}\n#{$!.backtrace.join("\n")}")
  end
end
Tk.mainloop
