$: << File.dirname(__FILE__) + '/..'
$: << File.dirname(__FILE__) + '/../../lib'
require 'tk'
require 'pongo'
require 'pongo/renderer/tk_renderer'
require 'pongo/logger/standard_logger'
require 'cardemo/surfaces'
require 'cardemo/bridge'
require 'cardemo/capsule'
require 'cardemo/swing_door'
require 'cardemo/car'
require 'cardemo/rotator'

include Pongo

col_a = 0x334433
col_b = 0x3366aa
col_c = 0xaabbbb
col_d = 0x6699aa
col_e = 0x778877

root = TkRoot.new {title 'Cardemo'}
canvas = TkCanvas.new(root, :width => 650, :height => 350)
canvas.pack
APEngine.renderer = Renderer::TkRenderer.new(canvas)
APEngine.logger = Logger::StandardLogger.new
APEngine.setup
APEngine.gravity = VectorForce.new(false, 0, 3)

surfaces = Surfaces.new(col_a, col_b, col_c, col_d, col_e)
APEngine.add_group(surfaces)

bridge = Bridge.new(col_b, col_c, col_d)
APEngine.add_group(bridge)

capsule = Capsule.new(col_c)
APEngine.add_group(capsule)

rotator = Rotator.new(col_b, col_e)
APEngine.add_group(rotator)

swing_door = SwingDoor.new(col_c)
APEngine.add_group(swing_door)

car = Car.new(col_c, col_e)
APEngine.add_group(car)

car.add_collidable_list(surfaces, bridge, rotator, swing_door, capsule)
capsule.add_collidable_list(surfaces, bridge, rotator, swing_door)

frame = TkFrame.new.pack
left_button = TkButton.new(
  :parent => frame, :text => 'left', :command => lambda{car.speed = -0.5}
).pack(:side => :left)
stop_button = TkButton.new(
  :parent => frame, :text => 'stop', :command => lambda{car.speed = 0}
).pack(:side => :left)
right_button = TkButton.new(
  :parent => frame, :text => 'right', :command => lambda{car.speed = 0.5}
).pack

TkTimer.start(10) do |timer|
  begin
    APEngine.step
    APEngine.draw
    rotator.rotate_by_radian(0.02)
  rescue
    APEngine.log($!)
    raise $!
  end
end
Tk.mainloop
